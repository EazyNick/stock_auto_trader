import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';

class NaverSignInButton extends StatelessWidget {
  Future<void> _handleSignIn(BuildContext context) async {
    try {
      final result = await FlutterNaverLogin.logIn();
      if (result.status == NaverLoginStatus.loggedIn) {
        _showDialog(context, 'Login successful', 'You have successfully logged in with Naver.');
      } else {
        _showDialog(context, 'Login failed', 'Failed to sign in with Naver.');
      }
    } catch (error) {
      print(error);
      _showDialog(context, 'Login failed', 'Failed to sign in with Naver: $error');
    }
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
                if (title == 'Login successful') {
                  Navigator.pushReplacementNamed(context, '/home'); // 홈 화면으로 이동
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleSignIn(context),
      child: Text('Sign in with Naver'),
    );
  }
}
