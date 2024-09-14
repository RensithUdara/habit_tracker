import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ProgressChart extends StatelessWidget {
  final List<DateTime> progress;

  ProgressChart({required this.progress});

  @override
  Widget build(BuildContext context) {
    // Data preparation for the chart
    final data = progress.map((date) {
      return ChartData(date: date, value: 1);
    }).toList();

    var series = [
      charts.Series<ChartData, DateTime>(
        id: 'Progress',
        domainFn: (ChartData data, _) => data.date,
        measureFn: (ChartData data, _) => data.value,
        data: data,
      )
    ];

    return SizedBox(
      height: 200,
      child: charts.TimeSeriesChart(series),
    );
  }
}

class ChartData {
  final DateTime date;
  final int value;

  ChartData({required this.date, required this.value});
}
