import 'package:flutter/material.dart';

class MajorIndicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Major Indices'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // 코스피 기능
              },
              child: Text('코스피'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 코스닥 기능
              },
              child: Text('코스닥'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 환율 기능
              },
              child: Text('환율'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 금리 기능
              },
              child: Text('금리'),
            ),
          ],
        ),
      ),
    );
  }
}
