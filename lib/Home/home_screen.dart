import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  // StatelessWidget을 상속받는 클래스에서는 build 메서드를 재정의해야 합니다.
  @override
  Widget build(BuildContext context) {
    // Scaffold 위젯을 반환합니다. Scaffold는 기본적인 화면 구조를 제공합니다.
    return Scaffold(
      // 앱 바 (상단 바)를 설정합니다
      appBar: AppBar(
        // 앱 바의 제목을 'Home Screen'으로 설정합니다.
        title: Text('Home Screen'),
      ),
      // Scaffold의 본문 (body) 부분을 설정합니다.
      body: Center(
        // Center 위젯은 자식 위젯을 가운데로 정렬합니다.
        child: Text('Welcome to the Home Screen!'),
        // Center 위젯의 자식으로 Text 위젯을 설정하여 화면에 텍스트를 표시합니다.
      ),
    );
  }
}
