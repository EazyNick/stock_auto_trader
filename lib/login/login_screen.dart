import 'package:flutter/material.dart';
import 'Button/login_button.dart';
import 'Button/signup_button.dart';
import '../utils/logger.dart' as utils_logger;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import '../home/home_screen.dart';

/// 로그인 화면을 나타내는 StatefulWidget
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

/// 로그인 화면의 상태를 관리하는 State 클래스
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final logger = utils_logger.getLogger(); // 로거 인스턴스 가져오기

  late Dio _dio; // late 키워드를 사용하여 나중에 초기화
  String? csrfToken; // CSRF 토큰 저장
  late CookieJar cookieJar;
  bool _isLoading = false; // 로딩 상태를 추적

  @override
  void initState() {
    super.initState();
    cookieJar = CookieJar();
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://fintech19190301.kro.kr/',
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 8),
      ),
    )..interceptors.addAll([LogInterceptor(responseBody: true), CookieManager(cookieJar)]); // 로그 인터셉터와 쿠키 매니저 추가
  }

  /// 서버에 로그인 요청을 보내는 메서드
  Future<void> _login(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (!_formKey.currentState!.validate()) {
      return; // 폼 유효성 검사에 실패하면 로그인 시도하지 않음
    }

    setState(() {
      _isLoading = true; // 로그인 시작 시 로딩 상태로 설정
    });

    // 만약 ID가 'admin'이고 PW가 '1234'라면, 서버 통신 없이 바로 홈 화면으로 이동
    if (email == 'admin@naver.com' && password == '19190301') {
      logger.i('Login successful with hardcoded credentials.');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login successful')));

      // HomeScreen으로 이동하면서 CSRF 토큰과 쿠키 매니저를 전달
      Navigator.pushReplacementNamed(context, '/home', arguments: {'csrfToken': 'dummy_csrf_token', 'cookieJar': cookieJar});
    } else {
      // 그렇지 않다면 서버와 통신하여 로그인 시도
      logger.i('Attempting to log in with email: $email');
      try {
        final response = await _dio.post(
          'api/accounts/login/',
          data: {
            'Email': email,
            'Password': password,
          },
        );
        // 로그인 성공 시 처리
        if (response.statusCode == 200) {
          logger.i('Login successful: ${response.data}');

          // CSRF 토큰 저장
          final setCookie = response.headers['set-cookie'];
          if (setCookie != null) {
            final csrfCookie = setCookie.firstWhere(
                    (element) => element.contains('csrftoken'),
                orElse: () => '');
            csrfToken = RegExp(r'csrftoken=([^;]+)')
                .firstMatch(csrfCookie)
                ?.group(1);
            logger.i('CSRF Token: $csrfToken');
          }

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login successful')));

          // HomeScreen으로 이동하면서 CSRF 토큰과 쿠키 매니저를 전달
          Navigator.pushReplacementNamed(context, '/home', arguments: {'csrfToken': csrfToken, 'cookieJar': cookieJar});
        } else {
          logger.e('Login failed: ${response.data}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: ${response.data}')));
        }
      } on DioError catch (e) {
        // 로그인 실패 시 처리
        if (e.response != null) {
          logger.e('Login failed: ${e.response?.data}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: ${e.response?.data}')));
        } else {
          logger.e('Login failed: ${e.message}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: ${e.message}')));
        }
      } finally {
        setState(() {
          _isLoading = false; // 로그인 완료 시 로딩 상태 해제
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: '이메일'),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return '유효한 이메일 주소를 입력하세요';
                  }
                  return null;
                },
                controller: _emailController,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '비밀번호'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return '비밀번호는 최소 6자 이상이어야 합니다';
                  }
                  return null;
                },
                controller: _passwordController,
              ),
              SizedBox(height: 16.0),
              _isLoading
                  ? CircularProgressIndicator() // 로딩 중일 때 로딩 인디케이터 표시
                  : LoginButton(
                emailController: _emailController,
                passwordController: _passwordController,
                onPressed: () {
                  logger.i('Login button pressed.');
                  _login(context);
                },
              ),
              SizedBox(height: 16.0),
              SignupButton(),
            ],
          ),
        ),
      ),
    );
  }
}
