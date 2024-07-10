import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // 자산 확인 기능
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AssetCheckScreen()),
                );
              },
              child: Text('자산 확인 - 총 자산 간편 확인'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 투자 정보 기능
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
                // 종목 순위 기능
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
                // 주요 지수 기능
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
                // 관심종목/보유종목 기능
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
                // 수익률 상위 종목 기능
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
    );
  }
}

class AssetCheckScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asset Check'),
      ),
      body: Center(
        child: Text('총 자산 간편 확인 화면입니다'),
      ),
    );
  }
}

class InvestmentInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Investment Info'),
      ),
      body: Center(
        child: Text('오늘의 투자 정보 화면입니다.'),
      ),
    );
  }
}

class StockRankingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Ranking'),
      ),
      body: Center(
        child: Text('국내 기준으로 종목 순위 표시 화면입니다.'),
      ),
    );
  }
}

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

class TopPerformingStocksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Performing Stocks'),
      ),
      body: Center(
        child: Text('3개월간 수익률 높은 상위제품 표시 화면입니다.'),
      ),
    );
  }
}

