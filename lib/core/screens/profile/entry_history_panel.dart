import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rahener/core/models/measurement.dart';
import 'package:rahener/core/models/measurement_entry.dart';
import 'package:rahener/utils/constants.dart';

class EntryHistoryPanel extends StatefulWidget {
  final List<MeasurementEntry> entries;
  final Measurement measurement;
  final Function onConfirmEntryEditPressed;
  final Function showRemovalConfirmationDialog;
  final Function onEntryDissmissed;
  const EntryHistoryPanel(
      {super.key,
      required this.entries,
      required this.measurement,
      required this.onConfirmEntryEditPressed,
      required this.showRemovalConfirmationDialog,
      required this.onEntryDissmissed});

  @override
  State<EntryHistoryPanel> createState() => _EntryHistoryPanelState();
}

class _EntryHistoryPanelState extends State<EntryHistoryPanel> {
  final TextEditingController _editEntryController = TextEditingController();
  late final List<MeasurementEntry> _entries;
  late final Measurement _measurement;
  late final Function _onConfirmEntryEditPressed;
  late final Function _showRemovalConfirmationDialog;
  late final Function _onEntryDissmissed;
  int? _indexOfEntryEdited;

  @override
  void initState() {
    _entries = widget.entries;
    _measurement = widget.measurement;
    _onConfirmEntryEditPressed = widget.onConfirmEntryEditPressed;
    _showRemovalConfirmationDialog = widget.showRemovalConfirmationDialog;
    _onEntryDissmissed = widget.onEntryDissmissed;
    super.initState();
  }

  Future<void> _onEditEntryPressed(int index) async {
    _editEntryController.clear();
    setState(() {
      _indexOfEntryEdited = index;
    });
  }

  Widget _buildEmptyEntries() {
    double iconSize = 64.0;
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Icon(
                  Icons.close,
                  size: iconSize,
                  color: Colors.grey,
                ),
                Icon(
                  Icons.list_alt_outlined,
                  size: iconSize,
                  color: Colors.grey,
                )
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'No entries added yet',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_entries.isEmpty) {
      return _buildEmptyEntries();
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      key: UniqueKey(),
      itemCount: _entries.length,
      itemBuilder: (context, index) {
        DateTime rawDate = _entries[index].entryDate;
        String dateStr = "${rawDate.year}-${rawDate.month}-${rawDate.day}";
        String valueStr = '${_entries[index].value} (${_measurement.unit})';

        Widget mainContent = Text(valueStr);
        Widget trailingContent = IconButton(
            icon: const Icon(
              Icons.edit,
              size: 19,
            ),
            onPressed: () => _onEditEntryPressed(index));

        if ((_indexOfEntryEdited != null) && _indexOfEntryEdited == index) {
          mainContent = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 70),
                child: FocusScope(
                  onFocusChange: (value) {
                    if (value == false) {
                      setState(() {
                        _indexOfEntryEdited = null;
                      });
                    }
                  },
                  child: TextField(
                    maxLength: Constants.maxMeasurementEntry,
                    keyboardType: TextInputType.number,
                    controller: _editEntryController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                    ],
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(
                            top: 3, bottom: 3, right: 10, left: 12),
                        isDense: true,
                        filled: true,
                        counterText: ""),
                  ),
                ),
              ),
              Text(" (${widget.measurement.unit})")
            ],
          );
          trailingContent = IconButton(
              icon: Icon(
                Icons.check_sharp,
                size: 23,
                color: _editEntryController.text.isEmpty
                    ? null
                    : Theme.of(context).primaryColor,
              ),
              onPressed: _editEntryController.text.isEmpty
                  ? null
                  : () => _onConfirmEntryEditPressed());
        }
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          background: Container(
            padding: const EdgeInsets.only(left: 300),
            color: Theme.of(context).colorScheme.error,
            child: Center(
                child: Text(
              "remove",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: Constants.fontSize4),
            )),
          ),
          child: ListTile(
            title: mainContent,
            subtitle: Text(dateStr),
            trailing: trailingContent,
          ),
          confirmDismiss: (direction) {
            return _showRemovalConfirmationDialog();
          },
          onDismissed: (direction) {
            _onEntryDissmissed(index);
          },
        );
      },
    );
  }
}
