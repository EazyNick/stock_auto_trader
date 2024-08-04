import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInButton extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> _handleSignIn(BuildContext context) async {
    try {
      await _googleSignIn.signIn();
      // 로그인 성공 시 처리
      _showDialog(context, 'Login successful', 'You have successfully logged in with Google.');
    } catch (error) {
      print(error);
      _showDialog(context, 'Login failed', 'Failed to sign in with Google: $error');
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
      child: Text('Sign in with Google'),
    );
  }
}
