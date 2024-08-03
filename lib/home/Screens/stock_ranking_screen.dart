import 'package:flutter/material.dart';

class StockRankingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Ranking'),
      ),
      body: Center(
        child: Text('국내 기준으로 종목 순위 표시 화면입니다.'),
      ),
    );
  }
}
