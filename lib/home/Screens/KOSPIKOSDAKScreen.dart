import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dio/dio.dart';

class KOSPIKOSDAKScreen extends StatefulWidget {
  @override
  _KOSPIKOSDAKScreenState createState() => _KOSPIKOSDAKScreenState();
}

class _KOSPIKOSDAKScreenState extends State<KOSPIKOSDAKScreen> {
  List<FlSpot> kospiSpots = [];
  List<FlSpot> kosdaqSpots = [];

  Dio dio = Dio(); // Dio 인스턴스 생성

  @override
  void initState() {
    super.initState();
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    try {
      final response = await dio.get('https://fintech19190301.kro.kr/api/stock_data/');

      if (response.statusCode == 200) {
        final data = response.data;

        setState(() {
          kospiSpots = _convertDataToSpots(data['kospi_data']);
          kosdaqSpots = _convertDataToSpots(data['kosdaq_data']);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<FlSpot> _convertDataToSpots(List<dynamic> data) {
    List<FlSpot> spots = [];
    for (var i = 0; i < data.length; i++) {
      double x = i.toDouble(); // X 좌표는 인덱스를 사용
      double y = double.parse(data[i]['Close']); // Y 좌표는 'Close' 값을 사용
      spots.add(FlSpot(x, y));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KOSPI & KOSDAQ Charts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: kospiSpots.isEmpty || kosdaqSpots.isEmpty
            ? Center(child: CircularProgressIndicator()) // 데이터 로딩 중일 때 로딩 표시
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'KOSPI Chart',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: kospiSpots,
                      isCurved: true,
                      colors: [Colors.blue],
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                          show: true,
                          colors: [Colors.blue.withOpacity(0.3)]
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'KOSDAQ Chart',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: kosdaqSpots,
                      isCurved: true,
                      colors: [Colors.red],
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                          show: true,
                          colors: [Colors.red.withOpacity(0.3)]
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
