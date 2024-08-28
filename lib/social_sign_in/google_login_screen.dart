// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:http/http.dart' as http;
import 'package:stock_auto_trader/social_sign_in/login_platform.dart';

class SampleScreen extends StatefulWidget {
  const SampleScreen({Key? key}) : super(key: key);

  @override
  State<SampleScreen> createState() => _SampleScreenState();
}

class _SampleScreenState extends State<SampleScreen> {
  LoginPlatform _loginPlatform = LoginPlatform.none;

  void signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      print('name = ${googleUser.displayName}');
      print('email = ${googleUser.email}');
      print('id = ${googleUser.id}');

      setState(() {
        _loginPlatform = LoginPlatform.google;
      });
    }
  }

  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.google:
        await GoogleSignIn().signOut();
        break;
      case LoginPlatform.kakao:
        break;
      case LoginPlatform.naver:
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: _loginPlatform != LoginPlatform.none
              ? _logoutButton()
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _loginButton(
                'google_logo',
                signInWithGoogle,
              )
            ],
          )),
    );
  }

  Widget _loginButton(String path, VoidCallback onTap) {
    return Card(
      elevation: 5.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
        image: AssetImage('asset/image/$path.png'),
        width: 60,
        height: 60,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(35.0),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return ElevatedButton(
      onPressed: signOut,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff0165E1),
      ),
      child: const Text('로그아웃'),
    );
  }
}