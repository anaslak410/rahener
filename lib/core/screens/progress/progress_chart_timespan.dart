import 'package:flutter/material.dart';

class ProgressDropdown extends StatefulWidget {
  final Function onChange;
  ProgressTimeSpan timeSpan;
  ProgressDropdown({
    Key? key,
    required this.onChange,
    required this.timeSpan,
  }) : super(key: key);

  @override
  _ProgressDropdownState createState() => _ProgressDropdownState();
}

class _ProgressDropdownState extends State<ProgressDropdown> {
  late ProgressTimeSpan _selectedOption;

  @override
  void initState() {
    _selectedOption = widget.timeSpan;
    super.initState();
  }

  String _enumToStr(ProgressTimeSpan enam) {
    switch (enam) {
      case ProgressTimeSpan.allTime:
        return "All Time";
      case ProgressTimeSpan.lastMonth:
        return "Last Month";
      case ProgressTimeSpan.lastYear:
        return "Last Year";
      case ProgressTimeSpan.lastThreeMonths:
        return "Last Three Months";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: DropdownButton<ProgressTimeSpan>(
        value: _selectedOption,
        onChanged: (ProgressTimeSpan? newValue) {
          _selectedOption = newValue!;
          widget.onChange(newValue);
        },
        items: <ProgressTimeSpan>[
          ProgressTimeSpan.lastMonth,
          ProgressTimeSpan.lastThreeMonths,
          ProgressTimeSpan.lastYear,
          ProgressTimeSpan.allTime,
        ].map<DropdownMenuItem<ProgressTimeSpan>>((ProgressTimeSpan value) {
          return DropdownMenuItem<ProgressTimeSpan>(
            value: value,
            child: Text(_enumToStr(value)),
          );
        }).toList(),
      ),
    );
  }
}

enum ProgressTimeSpan {
  lastMonth,
  lastThreeMonths,
  lastYear,
  allTime,
}
