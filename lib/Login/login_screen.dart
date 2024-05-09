import 'package:flutter/material.dart';
import '../home/home_screen.dart';  // 상대 경로로 정확하게 import

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // 로그인 로직이나 상태 관리를 처리할 부분
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Form(
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
              onSaved: (value) => _email = value ?? '',
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
              onSaved: (value) => _password = value ?? '',
            ),
            ElevatedButton(
              onPressed: _submit,
              child: Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
