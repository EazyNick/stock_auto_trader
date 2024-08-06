import 'package:flutter/material.dart';
import 'Home/Screens/home_screen.dart';
import 'Login/login_screen.dart';
import 'signup/signup_screen.dart';
<<<<<<< Updated upstream

void main() {
  // runApp 함수는 주어진 위젯을 화면에 그립니다. 여기서는 MyApp 위젯을 그립니다.
=======
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cookie_jar/cookie_jar.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
>>>>>>> Stashed changes
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< Updated upstream
      title: 'Flutter Demo', // 제목
=======
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
>>>>>>> Stashed changes
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
