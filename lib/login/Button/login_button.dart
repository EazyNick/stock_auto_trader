import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../utils/logger.dart'; // Logger를 가져옵니다.

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onPressed;
  final logger = getLogger(); // Logger 인스턴스 가져오기

  // `const` 키워드를 제거합니다.
  LoginButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.onPressed,
  }) : super(key: key);

  /// 로그인 요청을 처리하는 메서드
  ///
  /// [context]는 현재 빌드 컨텍스트입니다.
  Future<void> login(BuildContext context) async {
    logger.i('Attempting to log in with email: ${emailController.text}');

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
          'Email': emailController.text,
          'Password': passwordController.text,
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

  /// 로그인 버튼 위젯을 빌드하는 메서드
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        logger.i('Login button pressed.');
        onPressed();
      },
      child: Text('로그인'),
    );
  }
}
