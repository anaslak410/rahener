import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahener/core/blocs/measurements_cubit.dart';
import 'package:rahener/core/models/measurement.dart';
import 'package:rahener/core/models/measurement_entry.dart';
import 'package:rahener/core/screens/profile/add_entry_button.dart';
import 'package:rahener/core/screens/profile/entry_history_panel.dart';
import 'package:rahener/core/screens/progress/progress_chart.dart';
import 'package:rahener/utils/constants.dart';

class MeasurementEntriesScreen extends StatefulWidget {
  final Measurement measurement;
  const MeasurementEntriesScreen({
    super.key,
    required this.measurement,
  });

  @override
  State<MeasurementEntriesScreen> createState() =>
      _MeasurementEntriesScreenState();
}

class _MeasurementEntriesScreenState extends State<MeasurementEntriesScreen> {
  late final MeasurementsCubit _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MeasurementsCubit>(context);
  }

  void _onEntryDissmissed(int index) async {
    _bloc.removeMeasurementEntry(index, widget.measurement.name);
  }

  void _onAddEntryPressed(String text) {
    _bloc.addMeasurementEntry(
        MeasurementEntry(value: double.parse(text), entryDate: DateTime.now()),
        widget.measurement.name);
  }

  void _onConfirmEntryEditPressed(int index, MeasurementEntry newEntry) {
    _bloc.editMeasurementEntry(index, widget.measurement.name, newEntry);
  }

  Future<bool> _showRemovalConfirmationDialog() async {
    bool wantsToCancel = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Entry?'),
          content: const Text('Are you sure you want to remove this entry?'),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget>[
            FilledButton(
              onPressed: () {
                wantsToCancel = true;
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Constants.borderRadius),
                ),
              ),
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
    return wantsToCancel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.measurement.name} (${widget.measurement.unit})"),
      ),
      body: BlocBuilder<MeasurementsCubit, MeasurementsState>(
        builder: (context, state) {
          if (state is MeasurementsLoaded) {
            List<MeasurementEntry> entries =
                state.getMeasurementEntries(widget.measurement.name);
            var convertedEntries =
                state.getConvertedEntries(widget.measurement.name);
            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(
                    left: Constants.sideMargin, right: Constants.sideMargin),
                child: Column(
                  children: [
                    const SizedBox(height: Constants.margin4),
                    ProgressChart(
                        values: convertedEntries,
                        name: widget.measurement.name),
                    const SizedBox(height: Constants.margin4),
                    const Divider(),
                    const SizedBox(height: Constants.margin4),
                    const Text(
                      "History",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: Constants.fontSize5),
                    ),
                    const SizedBox(height: Constants.margin4),
                    AddEntryButton(onPressed: _onAddEntryPressed),
                    EntryHistoryPanel(
                      entries: entries,
                      measurement: widget.measurement,
                      onConfirmEntryEditPressed: _onConfirmEntryEditPressed,
                      onEntryDissmissed: _onEntryDissmissed,
                      showRemovalConfirmationDialog:
                          _showRemovalConfirmationDialog,
                    )
                  ],
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
