import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rahener/core/models/measurement.dart';
import 'package:rahener/core/models/measurement_entry.dart';
import 'package:rahener/core/screens/profile/edit_entry_list_item.dart';
import 'package:rahener/utils/constants.dart';

class EntryHistoryPanel extends StatefulWidget {
  final List<MeasurementEntry> entries;
  final Measurement measurement;
  final Function confirmEntryEdit;
  final Function showRemovalConfirmationDialog;
  final Function onEntryDissmissed;
  const EntryHistoryPanel(
      {super.key,
      required this.entries,
      required this.measurement,
      required this.confirmEntryEdit,
      required this.showRemovalConfirmationDialog,
      required this.onEntryDissmissed});

  @override
  State<EntryHistoryPanel> createState() => _EntryHistoryPanelState();
}

class _EntryHistoryPanelState extends State<EntryHistoryPanel> {
  final TextEditingController _editEntryController = TextEditingController();
  late final List<MeasurementEntry> _entries;
  late final Measurement _measurement;
  late final Function _confirmEntryEdit;
  late final Function _showRemovalConfirmationDialog;
  late final Function _onEntryDissmissed;
  int? _indexOfEntryEdited;

  @override
  void initState() {
    _entries = widget.entries;
    _measurement = widget.measurement;
    _confirmEntryEdit = widget.confirmEntryEdit;
    _showRemovalConfirmationDialog = widget.showRemovalConfirmationDialog;
    _onEntryDissmissed = widget.onEntryDissmissed;
    super.initState();
  }

  void _onConfirmEditEntryPressed(int index, MeasurementEntry newEntry) {
    setState(() {
      _indexOfEntryEdited = null;
    });
    _confirmEntryEdit(index, newEntry);
  }

  Future<void> _onEditEntryPressed(int index) async {
    _editEntryController.clear();
    setState(() {
      _indexOfEntryEdited = index;
    });
  }

  void _onEditEntryFieldFocusChanged(bool value) {
    if (value == false) {
      setState(() {
        _indexOfEntryEdited = null;
      });
    }
  }

  Widget _buildEmptyEntries() {
    double iconSize = 64.0;
    return SizedBox(
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
      reverse: true,
      itemCount: _entries.length,
      itemBuilder: (context, index) {
        DateTime rawDate = _entries[index].entryDate;
        String dateStr = "${rawDate.year}-${rawDate.month}-${rawDate.day}";
        String valueStr = '${_entries[index].value} (${_measurement.unit})';

        Widget listItem = ListTile(
          title: Text(valueStr),
          subtitle: Text(dateStr),
          trailing: IconButton(
              icon: const Icon(
                Icons.edit,
                size: 19,
              ),
              onPressed: () => _onEditEntryPressed(index)),
        );

        if ((_indexOfEntryEdited != null) && _indexOfEntryEdited == index) {
          listItem = EditEntryListItem(
            onConfirmEntryEditPressed: _onConfirmEditEntryPressed,
            measurementUnit: widget.measurement.unit,
            onEditEntryFieldFocusChanged: _onEditEntryFieldFocusChanged,
            date: rawDate,
            index: index,
          );
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
          child: listItem,
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
