import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'Button/login_button.dart';
import 'Button/signup_button.dart';
<<<<<<< Updated upstream
=======
import '../utils/logger.dart' as utils_logger;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import '../home/home_screen.dart';
>>>>>>> Stashed changes

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

<<<<<<< Updated upstream
=======
  late Dio _dio; // late 키워드를 사용하여 나중에 초기화
  String? csrfToken; // CSRF 토큰 저장
  late CookieJar cookieJar;

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

  /// 폼이 유효한지 검증하고 홈 화면으로 이동하는 메서드
>>>>>>> Stashed changes
  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
<<<<<<< Updated upstream
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _login(BuildContext context) async {
    Dio dio = Dio(
      BaseOptions(
        baseUrl: 'https://fintech19190301.kro.kr/',
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 3),
      ),
    )..interceptors.add(LogInterceptor(responseBody: true)); // 로그 인터셉터 추가

=======
      logger.i('Form is valid, navigating to home screen.');
      Navigator.pushReplacementNamed(context, '/home', arguments: {'csrfToken': csrfToken, 'cookieJar': cookieJar});
    } else {
      logger.w('Form validation failed.');
    }
  }

  /// 서버에 로그인 요청을 보내는 메서드
  Future<void> _login(BuildContext context) async {
    logger.i('Attempting to log in with email: ${_emailController.text}');
>>>>>>> Stashed changes
    try {
      final response = await _dio.post(
        'api/accounts/login/',
        data: {
          'Email': _emailController.text,
          'Password': _passwordController.text,
        },
      );
<<<<<<< Updated upstream
      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login successful')));
      Navigator.pushReplacementNamed(context, '/home');
=======
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
>>>>>>> Stashed changes
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response?.data);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: ${e.response?.data}')));
      } else {
        print(e.message);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: ${e.message}')));
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
              LoginButton(
                emailController: _emailController,
                passwordController: _passwordController,
                onPressed: () => _login(context),
              ),
              SignupButton(),
            ],
          ),
        ),
      ),
    );
  }
}
