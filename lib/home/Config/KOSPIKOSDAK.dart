import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class IndexChart extends StatelessWidget {
  final List<IndexData> data;

  IndexChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<IndexData, DateTime>> series = [
      charts.Series(
        id: "Index",
        data: data,
        domainFn: (IndexData series, _) => series.timestamp,
        measureFn: (IndexData series, _) => series.close,
      )
    ];

    return Container(
      height: 200,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                "Index Prices",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Expanded(
                child: charts.TimeSeriesChart(series, animate: true),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class IndexData {
  final DateTime timestamp;
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;

  IndexData({
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory IndexData.fromJson(Map<String, dynamic> json) {
    return IndexData(
      timestamp: DateTime.parse(json['Timestamp']),
      open: double.parse(json['Open']),
      high: double.parse(json['High']),
      low: double.parse(json['Low']),
      close: double.parse(json['Close']),
      volume: int.parse(json['Volume']),
    );
  }
}


