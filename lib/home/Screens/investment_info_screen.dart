import 'package:flutter/material.dart';

class InvestmentInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Investment Info'),
      ),
      body: Center(
        child: Text('오늘의 투자 정보 화면입니다.'),
      ),
    );
  }
}
