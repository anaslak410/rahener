// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:rahener/utils/constants.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Progress")),
      body: Container(
        margin: const EdgeInsets.only(
            left: Constants.sideMargin,
            right: Constants.sideMargin,
            top: Constants.sideMargin),
        height: 400,
        child: LineChartImp(values: [
          (20.50, DateTime.parse("2022-01-13T00:00:00")),
          (64.25, DateTime.parse("2022-02-13T00:00:00")),
          (124.0, DateTime.parse("2022-03-13T00:00:00")),
          (100.0, DateTime.parse("2022-11-01T00:00:00")),
          (124.56, DateTime.parse("2022-11-03T00:00:00")),
          (80.56, DateTime.parse("2022-11-07T00:00:00")),
          (45.67, DateTime.parse("2022-11-09T00:00:00")),
          (90.67, DateTime.parse("2022-11-22T00:00:00")),
          (189.23, DateTime.parse("2023-03-18T00:00:00")),
          (78.45, DateTime.parse("2023-05-16T00:00:00")),
          (12.34, DateTime.parse("2023-11-17T00:00:00")),
        ]),
      ),
    );
  }
}

class LineChartImp extends StatefulWidget {
  final List<(double, DateTime)> values;

  const LineChartImp({
    Key? key,
    required this.values,
  }) : super(key: key);

  @override
  State<LineChartImp> createState() => LineChartImpState();
}

class LineChartImpState extends State<LineChartImp> {
  List<FlSpot> spots = [];
  final double _maxX = 1;
  double _minX = 0;
  final double _minY = 1;
  late final double _yinterval;
  late final double _xinterval;
  double _maxY = 0;

  @override
  void initState() {
    super.initState();
    for (var value in widget.values) {
      if (value.$1 > _maxY) {
        _maxY = value.$1;
      }
      double timeDifference = -(_daysBetween(value.$2, DateTime.now()));

      spots.add(FlSpot(timeDifference, value.$1));

      log(timeDifference.toString());
      if (timeDifference < _minX) {
        _minX = timeDifference;
      }
    }

    switch (_maxY) {
      case < 20:
        _yinterval = 1;
      case < 40:
        _yinterval = 2.5;
      case < 100:
        _yinterval = 5;
      case < 200:
        _yinterval = 10;
      case < 400:
        _yinterval = 20;
      case < 1000:
        _yinterval = 50;
      case < 2000:
        _yinterval = 100;
      case > 2000:
        throw Exception("weight bigger than 2000");
    }

    // switch (-_minX) {
    //   case < 10:
    //     _xinterval = 1;
    //   case < 20:
    //     _xinterval = 2;
    //   case < 30:
    //     _xinterval = 3;
    //   case < 60:
    //     _xinterval = 6;
    //   case < 90:
    //     _xinterval = 9;
    //   case < 120:
    //     _xinterval = 12;
    // }
    _xinterval = (-1 * _minX) / 2;
    log(_xinterval.toString());
  }

  double _daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round().toDouble();
  }

  LineTouchData get lineTouchData => const LineTouchData(
        enabled: true,
      );

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = "";
    if (value % 1 == 0) {
      text = value.toInt().toString();
    } else {
      text = value.toString();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: _yinterval,
        reservedSize: 55,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day + value.toInt());
    List months = [
      'jan',
      'feb',
      'mar',
      'april',
      'may',
      'jun',
      'july',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec'
    ];

    Widget text;
    switch (-(_minX)) {
      case < 7:
        text = Text(_getWeekday(date.weekday), style: style);
        break;
      case < 31:
        text = Text("${date.day}", style: style);
        break;
      case < 91:
        text = Text("${date.month}-${date.day}", style: style);
        break;
      case < 360:
        text = Text("${months[date.month + 1]}", style: style);
        break;
      case < 550:
        text = Text("${date.year}-${date.month}", style: style);
        break;
      default:
        text = Text("${date.year}", style: style);
    }

    return SideTitles(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: _xinterval,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData => LineChartBarData(
      isCurved: true,
      curveSmoothness: 0,
      color: Theme.of(context).primaryColor.withOpacity(0.5),
      barWidth: 4,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: spots);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: lineTouchData,
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: [lineChartBarData],
        maxX: _maxX,
        minX: _minX,
        maxY: _maxY,
        minY: _minY,
      ),
      duration: const Duration(milliseconds: 250),
    );
  }

  String _getWeekday(int day) {
    switch (day) {
      case 1:
        return "Mon";
      case 2:
        return "Tues";
      case 3:
        return "Wed";
      case 4:
        return "Thur";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        throw Exception("$day not a valid weekday");
    }
  }
}
