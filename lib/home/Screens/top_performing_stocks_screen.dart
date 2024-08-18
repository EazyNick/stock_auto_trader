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
            ElevatedButton(
              onPressed: null, // 버튼을 비활성화
              child: Text('주식 AI자동매매 시작/중지 (업데이트 예정...)'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: null, // 버튼을 비활성화
              child: Text('투자할 자동매매 금액 확인 (업데이트 예정...)'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: null, // 버튼을 비활성화
              child: Text('수익률 표시 (업데이트 예정...)'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: null, // 버튼을 비활성화
              child: Text('AI 매매 내역 표시 (업데이트 예정...)'),
            ),
          ],
        ),
      ),
    );
  }
}
