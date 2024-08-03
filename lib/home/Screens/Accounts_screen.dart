import 'package:flutter/material.dart';

class AccountsCheckScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts Check'),
      ),
      body: Center(
        child: Text('총 자산 간편 확인 화면입니다'),
      ),
    );
  }
}
