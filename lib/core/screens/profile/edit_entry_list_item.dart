import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rahener/core/models/measurement_entry.dart';

import 'package:rahener/utils/constants.dart';

class EditEntryListItem extends StatefulWidget {
  final DateTime date;
  final int index;
  final String measurementUnit;
  final Function onConfirmEntryEditPressed;
  final Function onEditEntryFieldFocusChanged;
  const EditEntryListItem({
    Key? key,
    required this.date,
    required this.onConfirmEntryEditPressed,
    required this.measurementUnit,
    required this.onEditEntryFieldFocusChanged,
    required this.index,
  }) : super(key: key);

  @override
  State<EditEntryListItem> createState() => _EditEntryListItemState();
}

class _EditEntryListItemState extends State<EditEntryListItem> {
  final TextEditingController _editEntryController = TextEditingController();
  late final String _dateStr;
  @override
  void initState() {
    super.initState();
    _dateStr = "${widget.date.year}-${widget.date.month}-${widget.date.day}";
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 70),
            child: FocusScope(
              onFocusChange: (value) {
                widget.onEditEntryFieldFocusChanged(value);
              },
              child: TextField(
                maxLength: Constants.maxMeasurementEntry,
                keyboardType: TextInputType.number,
                controller: _editEntryController,
                autofocus: true,
                onChanged: (value) {
                  setState(() {});
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                ],
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: 3, bottom: 3, right: 10, left: 12),
                    isDense: true,
                    filled: true,
                    counterText: ""),
              ),
            ),
          ),
          Text(" (${widget.measurementUnit})")
        ],
      ),
      subtitle: Text(_dateStr),
      trailing: IconButton(
          icon: Icon(
            Icons.check_sharp,
            size: 23,
            color: _editEntryController.text.isEmpty
                ? null
                : Theme.of(context).primaryColor,
          ),
          onPressed: _editEntryController.text.isEmpty
              ? null
              : () => widget.onConfirmEntryEditPressed(
                  widget.index,
                  MeasurementEntry(
                      value: double.parse(_editEntryController.text),
                      entryDate: widget.date))),
    );
  }
}
