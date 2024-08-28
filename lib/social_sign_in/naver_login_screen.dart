import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:http/http.dart' as http;
import 'login_platform.dart';

// 네이버 로그인 상태를 정의하는 열거형
enum NaverLoginStatus { loggedIn, cancelledByUser, error }

// 네이버 로그인 결과를 나타내는 클래스
class MyNaverLoginResult {
  final NaverLoginStatus status;
  final NaverAccountResult account;
  final String errorMessage;
  final NaverAccessToken accessToken;

  MyNaverLoginResult({
    required this.status,
    required this.account,
    required this.errorMessage,
    required this.accessToken,
  });

  bool get isSuccess => status == NaverLoginStatus.loggedIn;
}

// 네이버 계정 정보를 담는 클래스
class MyNaverAccountResult {
  final String id;
  final String name;
  final String email;

  MyNaverAccountResult({
    required this.id,
    required this.name,
    required this.email,
  });
}

// 네이버 액세스 토큰을 담는 클래스
class MyNaverAccessToken {
  final String token;

  MyNaverAccessToken({required this.token});
}
void main() {
  // MyNaverAccessToken 인스턴스 생성
  MyNaverAccessToken myNaverAccessToken = MyNaverAccessToken(token: 'sample_token');

  // accessToken 변수를 정의하고 초기화
  String accessToken = myNaverAccessToken.token;

  // Access Token 출력
  print('Access Token: $accessToken');
}

class SampleScreen extends StatefulWidget {
  const SampleScreen({Key? key}) : super(key: key);

  @override
  State<SampleScreen> createState() => _SampleScreenState();
}

class _SampleScreenState extends State<SampleScreen> {
  LoginPlatform _loginPlatform = LoginPlatform.none;

  void signInWithNaver() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    if (result.status == NaverLoginStatus.loggedIn) {
      print('accessToken = ${result.accessToken}');
      print('id = ${result.account.id}');
      print('email = ${result.account.email}');
      print('name = ${result.account.name}');

      setState(() {
        _loginPlatform = LoginPlatform.naver;
      });
    }
  }

  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.google:
        break;
      case LoginPlatform.kakao:
        break;
      case LoginPlatform.naver:
        await FlutterNaverLogin.logOut();
        break;
      default:
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _loginButton(
                'naver_logo',
                signInWithNaver,
              ),
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