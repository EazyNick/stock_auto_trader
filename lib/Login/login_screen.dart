import 'package:flutter/material.dart';
import 'button/login_button.dart';
import 'button/signup_button.dart';

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
      // 폼의 상태를 저장
      _formKey.currentState!.save();
      // main.dart에서 Route로 맵핑 필요
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  // 부모 클래스의 build 메서드를 재정의
  Widget build(BuildContext context) {
    // Scaffold 위젯은 기본적인 화면 레이아웃 구조를 제공
    return Scaffold(
      // 상단 앱 바를 정의
      appBar: AppBar(
        // 앱 바의 제목을 '로그인'으로 설정합니다.
        title: Text('로그인'),
      ),
      // // Padding 위젯은 주어진 padding 값만큼 자식 위젯 주위에 여백을 추가
      // Padding: 위젯 주위에 여백을 추가하는 데 사용
      body: Padding(
        // 모든 방향에서 16.0의 여백을 추가
        padding: const EdgeInsets.all(16.0),
        // Form 위젯은 폼 필드를 포함하는 컨테이너 역할을 합니다.
        // Form 위젯은 여러 입력 필드를 포함하는 위젯으로, 폼의 상태를 관리
        child: Form(
          // Form의 상태를 관리하기 위한 키를 설정
          // 폼의 유효성 검사와 저장 상태를 관리하는 데 사용
          key: _formKey,
          // 세로로 위젯들을 배치하는 Column 위젯
          child: Column(
            // 자식 위젯들을 리스트 형태로 정의
            children: <Widget>[
              // 텍스트 입력 필드를 정의
              TextFormField(
                // 입력 필드의 레이블을 '이메일'로 설정
                decoration: InputDecoration(labelText: '이메일'),
                // 입력값을 검증하는 함수
                validator: (value) {
                  // 입력값이 null, 비어있거나 '@' 문자가 포함되지 않은 경우 메시지를 반환합니다.
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return '유효한 이메일 주소를 입력하세요';
                  }
                  // 입력값이 유효한 경우 null을 반환
                  return null;
                },
                // 폼이 저장될 때 호출되며, 입력값을 _email 변수에 저장합니다.
                onSaved: (value) => _email = value ?? '',
              ),
              // 비밀번호 입력 필드를 정의합니다.
              TextFormField(
                // 입력 필드의 레이블을 '비밀번호'로 설정합니다.
                decoration: InputDecoration(labelText: '비밀번호'),
                // 입력값을 가려서 표시합니다.
                obscureText: true,
                // 입력값을 검증하는 함수입니다.
                validator: (value) {
                  // 입력값이 null, 비어있거나 6자 미만인 경우 에러 메시지를 반환합니다.
                  if (value == null || value.isEmpty || value.length < 6) {
                    return '비밀번호는 최소 6자 이상이어야 합니다';
                  }
                  // 입력값이 유효한 경우 null을 반환합니다.
                  return null;
                },
                // 폼이 저장될 때 호출되며, 입력값을 _password 변수에 저장합니다.
                // onSaved 가 호출될 때, (value) 함수를 호출하는 것임.
                // (value) => 는 v0alue를 매개변수로 받는 함수이다. 함수 내용은 value를 _password에 넣는다.
                // ?? (널 병합 연산자), value가 null일 경우 ''을 반환
                onSaved: (value) => _password = value ?? '',
              ),
              // 버튼 위젯을 정의합니다.
              // ElevatedButton(입체적), TextButton(평평) 차이는 모양이 다름
              LoginButton(
                // 버튼이 눌렸을 때 _submit 메서드를 호출합니다.
                // _submit 메서드에서 validate() 메서드를 호출하여 폼의 모든 필드를 검증
                // validate()가 true를 반환하면 save() 메서드를 호출
                // save() 메서드는 Form의 각 TextFormField 위젯에 정의된 onSaved 콜백을 실행하여 입력된 값을 저장
                onPressed: _submit,
                // 버튼의 텍스트를 '로그인'으로 설정합니다.
              ),
              SignupButton(),  // SignupButton 위젯을 사용합니다.
            ],
          ),
        ),
      ),
    );
  }
}