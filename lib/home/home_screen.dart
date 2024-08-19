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

// 코스피/코스닥 그래프 선의 색상을 결정하는 함수
List<Color> _getLineColor(List<FlSpot> spots) {
  if (spots.isEmpty) return [Colors.grey];  // 데이터가 없을 경우 회색
  final lastYValue = spots.last.y;
  return lastYValue >= 0 ? [Colors.red] : [Colors.blue];  // 양수이면 빨강, 음수이면 파랑
}

// 코스피/코스닥 그래프 영역 색상을 결정하는 함수
List<Color> _getFillColor(List<FlSpot> spots) {
  if (spots.isEmpty) return [Colors.grey.withOpacity(0.3)];  // 데이터가 없을 경우 회색
  final lastYValue = spots.last.y;
  return lastYValue >= 0
      ? [Colors.red.withOpacity(0.3)]
      : [Colors.blue.withOpacity(0.3)];  // 양수이면 빨강, 음수이면 파랑
}

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
  double kospiLatestClose = 0.0;
  double kosdaqLatestClose = 0.0;

  @override
  void initState() {
    super.initState();
    fetchChartData();  // 처음 화면 로딩 시 데이터 가져오기
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchChartData();  // 화면으로 다시 돌아올 때마다 데이터 가져오기
  }

  Future<void> fetchChartData() async {
    setState(() {
      isLoading = true;  // 데이터를 가져오는 동안 로딩 표시
    });

    try {
      Dio dio = Dio();
      final response = await dio.get('https://fintech19190301.kro.kr/api/stock_data/');

      if (response.statusCode == 200) {
        final data = response.data;

        setState(() {
          kospiLatestClose = double.parse(data['kospi_latest'][0]['Close']);
          kosdaqLatestClose = double.parse(data['kosdaq_latest'][0]['Close']);

          kospiSpots = _convertDataToSpots(data['kospi_today'], kospiLatestClose);
          kosdaqSpots = _convertDataToSpots(data['kosdaq_today'], kosdaqLatestClose);

          isLoading = false;  // 데이터 로딩 완료
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;  // 오류 발생 시에도 로딩 해제
      });
    }
  }

  List<FlSpot> _convertDataToSpots(List<dynamic> data, double latestClose) {
    if (data.isEmpty) return [];

    List<FlSpot> spots = [];
    for (var i = 0; i < data.length; i++) {
      double x = i.toDouble();
      double closePrice = double.parse(data[i]['Close']);
      double y = ((closePrice / latestClose) * 100) - 100;  // 퍼센트 변화 계산
      // 변화량을 증폭시키기 위해 y 값에 곱셈 적용 (예: 2배)
      y *= 2;  // 변화량을 2배로 증폭
      spots.add(FlSpot(x, y));
    }

    return spots;
  }

  double _calculateMinY(List<FlSpot> spots) {
    final minValue = spots.isEmpty ? 0.0 : spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    return minValue < -5.0 ? minValue.toDouble() : -5.0;  // 최소값을 -5%로 고정하되, 데이터가 더 작으면 그 값을 사용
  }

  double _calculateMaxY(List<FlSpot> spots) {
    final maxValue = spots.isEmpty ? 5.0 : spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    return maxValue > 5.0 ? maxValue.toDouble() : 5.0;  // 최대값을 5%로 고정하되, 데이터가 더 크면 그 값을 사용
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case '자산 확인':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountsCheckScreen()),
                  );
                  break;
                case '투자 정보':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InvestmentInfoScreen()),
                  );
                  break;
                case '종목 순위':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StockRankingScreen()),
                  );
                  break;
                case '주요 지수':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MajorIndicesScreen()),
                  );
                  break;
                case '관심종목/보유종목':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritesScreen()),
                  );
                  break;
                case 'AI 자동매매':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TopPerformingStocksScreen()),
                  );
                  break;
                case '챗봇':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatBotScreen(
                        csrfToken: widget.csrfToken,
                        cookieJar: widget.cookieJar,
                      ),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: '자산 확인',
                child: Text('자산 확인 - 총 자산 간편 확인'),
              ),
              const PopupMenuItem<String>(
                value: '투자 정보',
                child: Text('투자 정보 - 오늘의 투자 정보'),
              ),
              const PopupMenuItem<String>(
                value: '종목 순위',
                child: Text('종목 순위(국내기준)'),
              ),
              const PopupMenuItem<String>(
                value: '주요 지수',
                child: Text('주요 지수 - 국내 주요지수'),
              ),
              const PopupMenuItem<String>(
                value: '관심종목/보유종목',
                child: Text('관심종목/보유종목 - 빠른 종목 탐색'),
              ),
              const PopupMenuItem<String>(
                value: 'AI 자동매매',
                child: Text('주식 AI 자동매매 시작하기'),
              ),
              const PopupMenuItem<String>(
                value: '챗봇',
                child: Text('챗봇 - AI와의 대화'),
              ),
            ],
          ),
        ],
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
                                colors: _getLineColor(kospiSpots),  // 코스피 색상 설정
                                barWidth: 2,
                                belowBarData: BarAreaData(
                                    show: true,
                                    colors: _getFillColor(kospiSpots),  // 코스피 영역 색상 설정
                                ),
                                dotData: FlDotData(show: false), // 점 제거
                              ),
                            ],
                            axisTitleData: FlAxisTitleData(show: false),
                            lineTouchData: LineTouchData(enabled: false),

                            // 여기서 중앙에 실선을 추가
                            extraLinesData: ExtraLinesData(
                              horizontalLines: [
                                HorizontalLine(
                                  y: 0.0,  // Y=0에 실선을 추가
                                  color: Colors.grey,  // 실선 색상 설정
                                  strokeWidth: 1,  // 실선 두께 설정
                                  dashArray: [5, 5],  // 실선 스타일 (점선) 설정
                                ),
                              ],
                            ),
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

                            // 여기서 중앙에 실선을 추가
                            extraLinesData: ExtraLinesData(
                              horizontalLines: [
                                HorizontalLine(
                                  y: 0.0,  // Y=0에 실선을 추가
                                  color: Colors.grey,  // 실선 색상 설정
                                  strokeWidth: 1,  // 실선 두께 설정
                                  dashArray: [5, 5],  // 실선 스타일 (점선) 설정
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),  // 그래프와 버튼 사이의 여백
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
