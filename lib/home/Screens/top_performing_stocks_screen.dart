import 'package:flutter/material.dart';

class TopPerformingStocksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Performing Stocks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AT-03-01: 주식 AI자동매매 시작/중지'),
            SizedBox(height: 8.0),
            Text('AT-03-02: 투자할 자동매매 금액 확인'),
            SizedBox(height: 8.0),
            Text('AT-03-03: 수익률 표시'),
            SizedBox(height: 8.0),
            Text('AT-03-04: AI 매매 내역 표시'),
          ],
        ),
      ),
    );
  }
}