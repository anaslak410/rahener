import 'dart:developer';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rahener/core/screens/progress/progress_chart_timespan.dart';
import 'package:rahener/utils/constants.dart';

class LineChartImp extends StatefulWidget {
  final List<(double, DateTime)> values;
  final String name;

  const LineChartImp({
    Key? key,
    required this.values,
    required this.name,
  }) : super(key: key);

  @override
  State<LineChartImp> createState() => LineChartImpState();
}

class LineChartImpState extends State<LineChartImp> {
  late List<FlSpot> spots;
  final double _maxX = 0;
  double _smallestX = 0;
  late double _smallestY;
  late double _maxY;
  ProgressTimeSpan _timeSpan = ProgressTimeSpan.lastThreeMonths;
  late double _yinterval;
  late double _xinterval;

  @override
  void initState() {
    super.initState();

    _initValues();
  }

  void _initValues() {
    _setSpots();
    _setSmallestYandMaxY();
    _setYinterval();
    _setXinterval();

    log("max x is : ${_maxX.toString()}");
    log("min x is : ${_smallestX.toString()}");
  }

  void _setSpots() {
    spots = [];
    for (var value in widget.values) {
      double timeDifference = -(_daysBetween(value.$2, DateTime.now()));
      if (timeDifference > 0) {
        throw Exception("exercise time is in the future");
      }

      if (timeDifference < _smallestX) {
        _smallestX = timeDifference;
      }
      var minX = _calcMinX();
      if (timeDifference >= minX) {
        spots.add(FlSpot(timeDifference, value.$1));
      }
    }
  }

  void _setSmallestYandMaxY() {
    _smallestY = spots[0].y;
    _maxY = 0;
    for (var spot in spots) {
      if (spot.y < _smallestY) {
        _smallestY = spot.y;
      }
      if (spot.y > _maxY) {
        _maxY = spot.y;
      }
    }
  }

  void _setXinterval() {
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
    var minX = _calcMinX();
    log(minX.toString());
    _xinterval = (-1 * minX) / 7;
    log(_xinterval.toString());
  }

  double _calcMinY() {
    double minY = 0;
    if (_smallestY > (_maxY / 2)) {
      minY = ((_maxY - minY) / 2) + minY;
      while (_smallestY > ((_maxY - minY) / 2) + minY) {
        minY = ((_maxY - minY) / 2) + minY;
      }
    }
    return minY;
  }

  bool _thereIsEnoughData() {
    return spots.length > 2;
  }

  double _calcMinX() {
    switch (_timeSpan) {
      case ProgressTimeSpan.lastMonth:
        return -30;
      case ProgressTimeSpan.lastThreeMonths:
        return -90;
      case ProgressTimeSpan.lastYear:
        return -360;
      case ProgressTimeSpan.allTime:
        return _smallestX;
    }
  }

  void _setYinterval() {
    switch (_maxY - _calcMinY()) {
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
  }

  void _onTimeSpanChanged(ProgressTimeSpan newTimeSpan) {
    setState(() {
      _timeSpan = newTimeSpan;
      _initValues();
    });
  }

  double _daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round().toDouble();
  }

  DateTime _xToDate(double x) {
    return DateTime.now().subtract(Duration(days: -(x.toInt())));
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

  LineTouchData get _lineTouchData => LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            DateTime date = _xToDate(spot.x);
            return LineTooltipItem(
                "${spot.y}\n${date.year}-${date.month}-${date.day}",
                TextStyle(color: Theme.of(context).colorScheme.background));
          }).toList();
        },
      ));

  FlTitlesData get _titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: _bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          drawBelowEverything: false,
          sideTitles: _leftTitles(),
        ),
      );

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
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

    if (_maxY == value) {
      text = "";
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles _leftTitles() => SideTitles(
        getTitlesWidget: _leftTitleWidgets,
        showTitles: true,
        interval: _yinterval,
        reservedSize: 50,
      );

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    var minX = _calcMinX();
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day + value.toInt());
    Map months = {
      1: 'Jan',
      2: 'Feb',
      3: 'Mar',
      4: 'April',
      5: 'May',
      6: 'Jun',
      7: 'July',
      8: 'Aug',
      9: 'Sep',
      10: 'Oct',
      11: 'Nov',
      12: 'Dec'
    };

    Widget text;
    log((-minX).toString());
    switch (-(minX)) {
      case < 7:
        text = Text(_getWeekday(date.weekday), style: style);
        break;
      case < 31:
        text = Text("${date.day}", style: style);
        break;
      case < 91:
        text = Text("${months[date.month]}\n${date.day}", style: style);
        break;
      case < 360:
        text = Text("${months[date.month]}", style: style);
        break;
      case < 1000:
        text = Text("${date.year}\n${months[date.month]}", style: style);
        break;
      default:
        text = Text("${date.year}", style: style);
    }
    if (_maxX == value) {
      text = Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 50,
        interval: _xinterval,
        getTitlesWidget: _bottomTitleWidgets,
      );

  FlGridData get _gridData => FlGridData(
        show: true,
        drawVerticalLine: false,
        verticalInterval: _yinterval,
      );

  FlBorderData get _borderData => FlBorderData(
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

  LineChartBarData get _lineChartBarData => LineChartBarData(
      isCurved: false,
      color: Theme.of(context).primaryColor,
      barWidth: 2,
      dotData: FlDotData(
        show: true,
        getDotPainter: (p0, p1, p2, p3) {
          return FlDotCirclePainter(
              radius: 3,
              color: Theme.of(context).colorScheme.primary,
              strokeWidth: 0);
        },
      ),
      belowBarData: BarAreaData(show: false),
      isStrokeJoinRound: false,
      spots: spots);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.name,
            style: const TextStyle(
                fontSize: Constants.fontSize5, fontWeight: FontWeight.w500),
          ),
          ProgressDropdown(
            onChange: _onTimeSpanChanged,
            timeSpan: _timeSpan,
          ),
          Container(
            height: 400,
            padding:
                const EdgeInsets.only(left: 10, right: 20, top: 5, bottom: 20),
            child: _thereIsEnoughData()
                ? LineChart(
                    LineChartData(
                      backgroundColor:
                          Theme.of(context).colorScheme.onSecondary,
                      lineTouchData: _lineTouchData,
                      gridData: _gridData,
                      titlesData: _titlesData,
                      borderData: _borderData,
                      lineBarsData: [_lineChartBarData],
                      maxX: _maxX,
                      minX: _calcMinX(),
                      maxY: _maxY,
                      minY: _calcMinY(),
                    ),
                    duration: const Duration(milliseconds: 250),
                  )
                : Stack(
                    children: [
                      LineChart(
                        LineChartData(
                          backgroundColor:
                              Theme.of(context).colorScheme.onSecondary,
                          lineTouchData: _lineTouchData,
                          gridData: _gridData,
                          titlesData: _titlesData,
                          borderData: _borderData,
                          lineBarsData: [],
                          maxX: 0,
                          minX: 0,
                          maxY: 0,
                          minY: 0,
                        ),
                        duration: const Duration(milliseconds: 250),
                      ),
                      Center(
                        child: const Text(
                          'Not enough data to create a chart.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
