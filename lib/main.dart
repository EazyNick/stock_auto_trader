import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'login/login_screen.dart';
import 'signup/signup_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cookie_jar/cookie_jar.dart';
// import 'social_sign_in/google_sign_in_button.dart'; // 구글 로그인 버튼 경로 추가
// import 'social_sign_in/naver_sign_in_button.dart'; // 네이버 로그인 버튼 경로 추가

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
      },
      // 홈 화면으로 이동할 때 CSRF 토큰과 쿠키 매니저를 전달
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final args = settings.arguments as Map<String, dynamic>;
          final csrfToken = args['csrfToken'] as String;
          final cookieJar = args['cookieJar'] as CookieJar;
          return MaterialPageRoute(
            builder: (context) => HomeScreen(csrfToken: csrfToken, cookieJar: cookieJar),
          );
        }
        // 다른 라우트를 처리
        return null;
      },
    );
  }
}
