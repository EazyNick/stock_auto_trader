import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  // onPressed라는 하나의 매개변수를 필요로 하며, 이 매개변수는 required 키워드를 사용하여 필수로 지정
  const LoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // 버튼이 눌렸을 때 호출될 콜백 함수를 설정합니다.
      onPressed: onPressed,
      // 버튼의 텍스트를 '로그인'으로 설정합니다.
      child: Text('로그인'),
    );
  }
}
