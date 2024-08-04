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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login successful'),
            content: Text('You have successfully logged in.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // 팝업 닫기
                  Navigator.pushReplacementNamed(context, '/home'); // 홈 화면으로 이동
                },
              ),
            ],
          );
        },
      );
    } on DioError catch (e) {
      // 로그인 실패 시 처리
      String errorMessage = e.response != null ? e.response?.data : e.message;
      print(errorMessage);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login failed'),
            content: Text('Login failed: $errorMessage'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // 팝업 닫기
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        login(context);
      },
      child: Text('로그인'),
    );
  }
}

