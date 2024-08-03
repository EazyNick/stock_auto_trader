import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'Button/login_button.dart';
import 'Button/signup_button.dart';
import '../utils/logger.dart' as utils_logger;

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

  /// 폼이 유효한지 검증하고 홈 화면으로 이동하는 메서드
  void _submit() {
    // 폼 검증
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      logger.i('Form is valid, navigating to home screen.');
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      logger.w('Form validation failed.');
    }
  }

  /// 서버에 로그인 요청을 보내는 메서드
  ///
  /// [context]는 현재 빌드 컨텍스트입니다.
  Future<void> _login(BuildContext context) async {
    logger.i('Attempting to log in with email: ${_emailController.text}');
    Dio dio = Dio(
      BaseOptions(
        baseUrl: 'https://fintech19190301.kro.kr/',
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 3),
      ),
    )..interceptors.add(LogInterceptor(responseBody: true)); // 로그 인터셉터 추가

    try {
      final response = await dio.post(
        'api/accounts/login/',
        data: {
          'Email': _emailController.text,
          'Password': _passwordController.text,
        },
      );
      // 로그인 성공 시 처리
      logger.i('Login successful: ${response.data}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login successful')));
      Navigator.pushReplacementNamed(context, '/home');
    } on DioError catch (e) {
      // 로그인 실패 시 처리
      if (e.response != null) {
        logger.e('Login failed: ${e.response?.data}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: ${e.response?.data}')));
      } else {
        logger.e('Login failed: ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: ${e.message}')));
      }
    }
  }

  /// 위젯 트리를 빌드하여 UI를 구성하는 메서드
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
              /// 이메일 입력 필드
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
              /// 비밀번호 입력 필드
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
              /// 로그인 버튼
              LoginButton(
                emailController: _emailController,
                passwordController: _passwordController,
                onPressed: () {
                  logger.i('Login button pressed.');
                  _login(context);
                },
              ),
              /// 회원가입 버튼
              SignupButton(),
            ],
          ),
        ),
      ),
    );
  }
}
