import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String _username = '';
  String _email = '';
  String _password = '';

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Dio dio = Dio(
        BaseOptions(
          baseUrl: 'https://fintech19190301.kro.kr/',
          connectTimeout: Duration(seconds: 5), // Duration 타입으로 변경
          receiveTimeout: Duration(seconds: 3), // Duration 타입으로 변경
        ),
      )..interceptors.add(LogInterceptor(responseBody: true)); // 로그 인터셉터 추가

      try {
        final response = await dio.post(
          'api/accounts/',
          data: {
            'Email': _email,
            'Password': _password,
            'username': _username,
          },
        );

        if (response.statusCode == 201) {
          // 회원가입 성공 시 로그인 페이지로 이동
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          // 서버로부터 에러 응답을 받은 경우 처리
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('회원가입 실패: ${response.statusMessage}')),
          );
        }
      } catch (e) {
        // 네트워크 오류 또는 다른 오류 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: '사용자 이름'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '유효한 사용자 이름을 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) => _username = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '이메일'),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return '유효한 이메일 주소를 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) => _email = value ?? '',
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: '비밀번호'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return '비밀번호는 최소 6자 이상이어야 합니다';
                  }
                  return null;
                },
                onSaved: (value) => _password = value ?? '',
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: '비밀번호 확인'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty || value != _passwordController.text) {
                    return '비밀번호가 일치하지 않습니다';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
