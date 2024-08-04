import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'login/login_screen.dart';
import 'signup/signup_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  // runApp 함수는 주어진 위젯을 화면에 그립니다. 여기서는 MyApp 위젯을 그립니다.
  runApp(MyApp());
}

// MyApp 클래스는 StatelessWidget을 상속받음
// extends 키워드를 사용하여 상속을 구현
// StatelessWidget은 상태가 변하지 않는 위젯을 정의할 때 사용
class MyApp extends StatelessWidget {
  const MyApp();

  // build 메서드는 위젯의 UI를 구성하는데 사용
  @override
  // 이 메서드는 StatelessWidget 또는 StatefulWidget 클래스에 있던 기존 build 함수를 자식함수 MyApp에서 재정의
  // 반환 타입이 Widget
  // BuildContext는 현재 위젯의 위치와 관련된 메타데이터를 제공
  Widget build(BuildContext context) {
    // MaterialApp은 Flutter 애플리케이션의 기본적인 설정을 제공
    return MaterialApp(
      debugShowCheckedModeBanner: false, // "debug" 배너를 숨깁니다.
      title: 'Flutter Demo', // 제목
      theme: ThemeData(
        primarySwatch: Colors.blue, // 테마 설정, primarySwatch는 주 색상
      ),
      home: LoginScreen(), // home 속성은 애플리케이션이 시작될 때 처음으로 보여줄 화면을 설정
      // routes 속성은 문자열 경로와 해당 경로에 매핑되는 위젯을 정의하는 맵(Map)입니다.
      // 이 맵은 경로 이름을 키(key)로, 해당 경로로 이동할 때 생성되는 위젯을 반환하는 함수로 구성
      // 경로이름 : (context) => 반환 위젯
      // Navigator.pushReplacementNamed(context, '/login'); 형식으로 화면 전환이 가능하게 해줌
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
