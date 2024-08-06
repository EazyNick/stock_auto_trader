import 'package:flutter/material.dart';
import 'Screens/Accounts_screen.dart';
import 'Screens/investment_info_screen.dart';
import 'Screens/stock_ranking_screen.dart';
import 'Screens/major_indices_screen.dart';
import 'Screens/favorites_screen.dart';
import 'Screens/top_performing_stocks_screen.dart';
import 'Screens/chatbot_screen.dart';
import 'package:cookie_jar/cookie_jar.dart';

class HomeScreen extends StatelessWidget {
  final String csrfToken; // CSRF 토큰을 받기 위해 추가
  final CookieJar cookieJar; // 쿠키 매니저를 받기 위해 추가

  HomeScreen({required this.csrfToken, required this.cookieJar}); // CSRF 토큰과 쿠키 매니저를 받는 생성자

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountsCheckScreen()),
                );
              },
              child: Text('자산 확인 - 총 자산 간편 확인'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InvestmentInfoScreen()),
                );
              },
              child: Text('투자 정보 - 오늘의 투자 정보'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StockRankingScreen()),
                );
              },
              child: Text('종목 순위(국내기준)'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MajorIndicesScreen()),
                );
              },
              child: Text('주요 지수 - 국내 주요지수'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesScreen()),
                );
              },
              child: Text('관심종목/보유종목 - 빠른 종목 탐색'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TopPerformingStocksScreen()),
                );
              },
              child: Text('수익률 상위 종목 Top3'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatBotScreen(csrfToken: csrfToken, cookieJar: cookieJar), // 챗봇 화면으로 CSRF 토큰과 쿠키 매니저 전달
            ),
          );
        },
        child: SizedBox(
          width: 40,
          height: 40,
          child: Image.asset(
            'assets/images/chatbot_icon.png',
            fit: BoxFit.contain,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
