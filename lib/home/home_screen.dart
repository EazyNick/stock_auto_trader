import 'package:flutter/material.dart';
import 'Screens/Accounts_screen.dart';
import 'Screens/investment_info_screen.dart';
import 'Screens/stock_ranking_screen.dart';
import 'Screens/major_indices_screen.dart';
import 'Screens/favorites_screen.dart';
import 'Screens/top_performing_stocks_screen.dart';
import 'Screens/chatbot_screen.dart';
import 'Screens/KOSPIKOSDAKScreen.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  final String csrfToken; // CSRF 토큰을 받기 위해 추가
  final CookieJar cookieJar; // 쿠키 매니저를 받기 위해 추가

  HomeScreen({required this.csrfToken, required this.cookieJar});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FlSpot> kospiSpots = [];
  List<FlSpot> kosdaqSpots = [];
  bool isLoading = true;
  double kospiYesterdayClose = 0.0;
  double kosdaqYesterdayClose = 0.0;

  @override
  void initState() {
    super.initState();
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    try {
      Dio dio = Dio();
      final response = await dio.get('https://fintech19190301.kro.kr/api/stock_data/');

      if (response.statusCode == 200) {
        final data = response.data;

        setState(() {
          kospiYesterdayClose = _getYesterdayClose(data['kospi_data'], 2000.0); // 코스피 기본값 2000
          kosdaqYesterdayClose = _getYesterdayClose(data['kosdaq_data'], 800.0); // 코스닥 기본값 800

          kospiSpots = _convertDataToSpots(data['kospi_data'], kospiYesterdayClose);
          kosdaqSpots = _convertDataToSpots(data['kosdaq_data'], kosdaqYesterdayClose);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  double _getYesterdayClose(List<dynamic> data, double defaultClose) {
    if (data.isEmpty) return defaultClose;
    final yesterdayData = data.firstWhere(
            (item) => DateTime.parse(item['Timestamp']).isBefore(DateTime.now()), orElse: () => null);
    return yesterdayData != null ? double.parse(yesterdayData['Close']) : defaultClose;
  }

  List<FlSpot> _convertDataToSpots(List<dynamic> data, double yesterdayClose) {
    if (data.isEmpty) return [];

    List<FlSpot> spots = [];
    for (var i = 0; i < data.length; i++) {
      double x = i.toDouble();
      double closePrice = double.parse(data[i]['Close']);
      double y = ((closePrice / yesterdayClose) * 100) - 98;
      spots.add(FlSpot(x, y));
    }

    return spots;
  }

  double _calculateMinY(List<FlSpot> spots) {
    return 0; // Y축의 최소값을 0으로 고정
  }

  double _calculateMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 5; // 데이터가 없을 때 기본 최대값을 5%로 설정
    final maxValue = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    return maxValue < 0 ? 5 : maxValue; // Ensure there's room above 0%
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '코스피',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 150,
                        child: LineChart(
                          LineChartData(
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(show: false),
                            minY: _calculateMinY(kospiSpots),
                            maxY: _calculateMaxY(kospiSpots),
                            lineBarsData: [
                              LineChartBarData(
                                spots: kospiSpots,
                                isCurved: true,
                                colors: [Colors.red],
                                barWidth: 2,
                                belowBarData: BarAreaData(
                                    show: true, colors: [Colors.red.withOpacity(0.3)]),
                                  dotData: FlDotData(show: false), // 점 제거
                              ),
                            ],
                            axisTitleData: FlAxisTitleData(show: false),
                            lineTouchData: LineTouchData(enabled: false),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '코스닥',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 150,
                        child: LineChart(
                          LineChartData(
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(show: false),
                            minY: _calculateMinY(kosdaqSpots),
                            maxY: _calculateMaxY(kosdaqSpots),
                            lineBarsData: [
                              LineChartBarData(
                                spots: kosdaqSpots,
                                isCurved: true,
                                colors: [Colors.blue],
                                barWidth: 2,
                                belowBarData: BarAreaData(
                                    show: true, colors: [Colors.blue.withOpacity(0.3)]),
                                    dotData: FlDotData(show: false), // 점 제거
                              ),
                            ],
                            axisTitleData: FlAxisTitleData(show: false),
                            lineTouchData: LineTouchData(enabled: false),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountsCheckScreen()),
                );
              },
              child: Text('자산 확인 - 총 자산 간편 확인'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InvestmentInfoScreen()),
                );
              },
              child: Text('투자 정보 - 오늘의 투자 정보'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StockRankingScreen()),
                );
              },
              child: Text('종목 순위(국내기준)'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MajorIndicesScreen()),
                );
              },
              child: Text('주요 지수 - 국내 주요지수'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FavoritesScreen()),
                );
              },
              child: Text('관심종목/보유종목 - 빠른 종목 탐색'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TopPerformingStocksScreen()),
                );
              },
              child: Text('주식 AI 자동매매 시작하기'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatBotScreen(
                  csrfToken: widget.csrfToken,
                  cookieJar: widget.cookieJar), // 챗봇 화면으로 CSRF 토큰과 쿠키 매니저 전달
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
