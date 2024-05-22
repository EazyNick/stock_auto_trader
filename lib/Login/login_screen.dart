import 'package:flutter/material.dart';
import '../home/home_screen.dart';  // 상대 경로로 정확하게 import

//StatefulWidget은 상태를 가지는 위젯을 정의할 때 사용됩니다.
class LoginScreen extends StatefulWidget {
  @override
  /*
  createState 메서드는 StatefulWidget에서 반드시 구현해야 하는 메서드로, State 객체를 반환합니다.
  여기서는 _LoginScreenState 객체를 반환합니다.
  반환타입 메서드() => 생성객체
  */
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /*
  final 키워드는 해당 변수가 한 번만 할당될 수 있음을 의미
  _formKey는 변수를 식별하는 이름입니다. 앞에 밑줄(_)이 붙어 있어 이 변수가 프라이빗(private)임을 나타냅니다.
  이는 이 변수에 접근할 수 있는 범위가 해당 클래스 내로 제한됨을 의미합니다.
  GlobalKey는 Flutter에서 특정 위젯의 상태에 접근할 수 있게 해주는 키로
  Form 위젯의 상태에 접근하고 조작하기 위해 사용
  폼의 상태를 관리하기 위한 GlobalKey를 생성합니다.
  = FormState 객체를 식별할 수 있는 고유한 키를 생성
  */
  final _formKey = GlobalKey<FormState>();
  // 이메일과 비밀번호를 저장할 변수를 선언합니다.
  String _email = '';
  String _password = '';

  // 폼 제출을 처리하는 메서드입니다.
  void _submit() {
    // 폼이 유효한지 검사합니다. '!'는 null이 아님을 보장
    if (_formKey.currentState!.validate()) {
      // 폼의 상태를 저장합니다.
      _formKey.currentState!.save();
      // 로그인 로직이나 상태 관리를 처리할 부분
      // 로그인 성공 시 홈 화면으로 이동합니다.
      // pushReplacement 메서드는 현재 화면을 새로운 화면으로 대체합니다. 즉, 새로운 화면으로 전환하고 이전 화면을 제거
      Navigator.pushReplacement(
        context, // context는 현재 위젯 트리에서 이 위젯의 위치를 나타내는 BuildContext입니다. 화면 전환 시 필요한 정보임
        MaterialPageRoute(builder: (context) => HomeScreen()), // MaterialPageRoute는 화면 전환 애니메이션과 함께 새로운 페이지를 생성
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: '이메일'),
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return '유효한 이메일 주소를 입력하세요';
                }
                return null;
              },
              onSaved: (value) => _email = value ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 6) {
                  return '비밀번호는 최소 6자 이상이어야 합니다';
                }
                return null;
              },
              onSaved: (value) => _password = value ?? '',
            ),
            ElevatedButton(
              onPressed: _submit,
              child: Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
