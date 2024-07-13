import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onPressed;

  const LoginButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.onPressed,
  }) : super(key: key);

  Future<void> login(BuildContext context) async {
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
      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login successful')));
      Navigator.pushReplacementNamed(context, '/home');
    } on DioError catch (e) {
      // 로그인 실패 시 처리
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
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('로그인'),
    );
  }
}
