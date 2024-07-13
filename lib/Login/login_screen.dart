import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'button/login_button.dart';
import 'button/signup_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
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

    try {
      final response = await dio.post(
        'api/accounts/login/',
        data: {
          'Email': _emailController.text,
          'Password': _passwordController.text,
        },
      );
      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login successful')));
      Navigator.pushReplacementNamed(context, '/home');
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
