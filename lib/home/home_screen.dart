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
  final String csrfToken;
  final CookieJar cookieJar;

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

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    fetchChartData();  // 위젯이 업데이트될 때마다 데이터 가져오기
  }

  Future<void> fetchChartData() async {
    setState(() {
      isLoading = true;
    });

    try {
      Dio dio = Dio();
      final response = await dio.get('https://fintech19190301.kro.kr/api/stock_data/');

      if (response.statusCode == 200) {
        final data = response.data;

        setState(() {
          kospiLatestClose = double.parse(data['kospi_latest'][0]['Close']);
          kosdaqLatestClose = double.parse(data['kosdaq_latest'][0]['Close']);

          print('kospiLatestClose: $kospiLatestClose');
          print('kosdaqLatestClose: $kosdaqLatestClose');

          // // 테스트 데이터
          // kospiLatestClose = 2707.67;
          // kosdaqLatestClose = 773.47;

          kospiSpots = _convertDataToSpots(data['kospi_today'], kospiLatestClose);
          kosdaqSpots = _convertDataToSpots(data['kosdaq_today'], kosdaqLatestClose);

          print('kospiSpots1: $kospiSpots');
          print('kosdaqSpots1: $kosdaqSpots');

          if (data['kospi_today'].isNotEmpty) {
            kospiSpots = _convertDataToSpots(data['kospi_today'], kospiLatestClose);
          } else {
            kospiSpots = _convertDataToSpots([kospiLatestClose], kospiLatestClose);
            print('kospiSpots2: $kospiSpots');
          }

          if (data['kosdaq_today'].isNotEmpty) {
            kosdaqSpots = _convertDataToSpots(data['kosdaq_today'], kosdaqLatestClose);
          } else {
            kosdaqSpots = _convertDataToSpots([kosdaqLatestClose], kosdaqLatestClose);
            print('kosdaqSpots2: $kosdaqSpots');
          }

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

  List<FlSpot> _convertDataToSpots(List<dynamic> data, double latestClose) {
    if (data.isEmpty) return [];

    List<FlSpot> spots = [];
    for (var i = 0; i < data.length; i++) {
      double x = i.toDouble();
      double closePrice;

      if (data[i] is Map<String, dynamic>) {
        // 일반적인 경우: data[i]가 Map 타입일 때
        closePrice = double.parse(data[i]['Close']);
      } else if (data[i] is double) {
        // 대체 데이터로 사용할 경우: data[i]가 double 타입일 때
        closePrice = data[i];
      } else {
        continue;  // 예상치 못한 데이터 타입일 경우 건너뜀
      }

      double y = (((closePrice / latestClose) * 100) - 100) * 3;
      spots.add(FlSpot(x, y));
    }

    return spots;
  }

  List<LineChartBarData> _createLineChartBars(List<FlSpot> spots) {
    List<FlSpot> positiveSpots = [];
    List<FlSpot> negativeSpots = [];

    List<LineChartBarData> lineBars = []; // 라인 데이터들을 저장할 리스트

    for (int i = 0; i < spots.length; i++) {
      FlSpot currentSpot = spots[i];
      FlSpot? previousSpot = i > 0 ? spots[i - 1] : null;

      if (previousSpot != null && ((previousSpot.y >= 0 && currentSpot.y < 0) || (previousSpot.y < 0 && currentSpot.y >= 0))) {
        // 양수와 음수의 전환 지점에서 0에 대한 정확한 교차점 찾기
        double slope = (currentSpot.y - previousSpot.y) / (currentSpot.x - previousSpot.x);
        double zeroCrossX = previousSpot.x + (0 - previousSpot.y) / slope;
        FlSpot zeroSpot = FlSpot(zeroCrossX, 0);

        if (previousSpot.y >= 0) {
          positiveSpots.add(zeroSpot);
          lineBars.add(_createBarData(positiveSpots, Colors.red)); // 양수 구간을 추가
          positiveSpots = [];
          negativeSpots.add(zeroSpot);
        } else {
          negativeSpots.add(zeroSpot);
          print('Negative Spots: $negativeSpots');
          lineBars.add(_createBarData(negativeSpots, Colors.blue)); // 음수 구간을 추가
          negativeSpots = [];
          positiveSpots.add(zeroSpot);
        }
      }

      if (currentSpot.y >= 0) {
        positiveSpots.add(currentSpot);
      } else {
        negativeSpots.add(currentSpot);
      }
    }

    // 남은 양수/음수 구간을 추가
    if (positiveSpots.isNotEmpty) {
      lineBars.add(_createBarData(positiveSpots, Colors.red));
    }
    if (negativeSpots.isNotEmpty) {
      lineBars.add(_createBarData(negativeSpots, Colors.blue));
    }

    return lineBars;
  }

  LineChartBarData _createBarData(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      colors: [color],
      barWidth: 2,
      belowBarData: BarAreaData(
        show: true,
        colors: [color.withOpacity(0.3)],
        cutOffY: 0,
        applyCutOffY: true,
      ),
      dotData: FlDotData(show: false),
    );
  }

  double _calculateMinY(List<FlSpot> spots) {
    final minValue = spots.isEmpty ? 0.0 : spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    return minValue < -5.0 ? minValue.toDouble() : -5.0;
  }

  double _calculateMaxY(List<FlSpot> spots) {
    final maxValue = spots.isEmpty ? 5.0 : spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    return maxValue > 5.0 ? maxValue.toDouble() : 5.0;
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
                            lineBarsData: _createLineChartBars(kospiSpots),
                            axisTitleData: FlAxisTitleData(show: false),
                            lineTouchData: LineTouchData(
                              enabled: false,
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor: Colors.transparent,
                                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                                  return touchedSpots.map((LineBarSpot touchedSpot) {
                                    if (touchedSpot.y >= 0) {
                                      return LineTooltipItem(
                                        touchedSpot.y.toString(),
                                        const TextStyle(color: Colors.red),
                                      );
                                    } else {
                                      return LineTooltipItem(
                                        touchedSpot.y.toString(),
                                        const TextStyle(color: Colors.blue),
                                      );
                                    }
                                  }).toList();
                                },
                              ),
                            ),

                            // 중앙에 실선을 추가
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
                            lineBarsData: _createLineChartBars(kosdaqSpots),
                            axisTitleData: FlAxisTitleData(show: false),
                            lineTouchData: LineTouchData(
                              enabled: false,
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor: Colors.transparent,
                                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                                  return touchedSpots.map((LineBarSpot touchedSpot) {
                                    if (touchedSpot.y >= 0) {
                                      return LineTooltipItem(
                                        touchedSpot.y.toString(),
                                        const TextStyle(color: Colors.red),
                                      );
                                    } else {
                                      return LineTooltipItem(
                                        touchedSpot.y.toString(),
                                        const TextStyle(color: Colors.blue),
                                      );
                                    }
                                  }).toList();
                                },
                              ),
                            ),

                            // 중앙에 실선을 추가
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
