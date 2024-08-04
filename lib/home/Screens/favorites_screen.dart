import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites/Owned Stocks'),
      ),
      body: Center(
        child: Text('빠른 종목 탐색 화면입니다.'),
      ),
    );
  }
}
