import 'package:flutter/material.dart';

class TopPerformingStocksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Performing Stocks'),
      ),
      body: Center(
        child: Text('3개월간 수익률 높은 상위제품 표시 화면입니다.'),
      ),
    );
  }
}
