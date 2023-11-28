import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahener/core/blocs/measurements_cubit.dart';
import 'package:rahener/core/models/measurement.dart';
import 'package:rahener/core/screens/profile/add_measurement_dialog.dart';
import 'package:rahener/core/screens/profile/measurement_entries_screen.dart';
import 'package:rahener/utils/constants.dart';

class MeasurementsPanel extends StatefulWidget {
  const MeasurementsPanel({super.key});

  @override
  State<MeasurementsPanel> createState() => _MeasurementsPanelState();
}

class _MeasurementsPanelState extends State<MeasurementsPanel> {
  late final MeasurementsCubit _bloc;
  bool _editIsActive = false;

  @override
  void initState() {
    _bloc = BlocProvider.of<MeasurementsCubit>(context);
    super.initState();
  }

  void _onMeasurementPressed(Measurement measurement) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return BlocProvider.value(
              value: _bloc,
              child: MeasurementEntriesScreen(
                measurement: measurement,
              ));
        },
      ),
    );
  }

  void _onEditButtonPressed() {
    setState(() {
      _editIsActive = !_editIsActive;
    });
  }

  void _confirmMeasurementAddition(Measurement measurement) {
    if (_bloc.measurementExists(measurement.name)) {
      var snackbar = _buildMeasurementSnackbar(
          message:
              "Measurement not saved, a measurement with the same name already exists",
          context: context,
          color: Theme.of(context).colorScheme.error);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      _bloc.addMeasurement(measurement);
    }
  }

  void _confirmMeasurementRemoval(String name) {
    _bloc.removeMeasurement(name);
    var snackbar = _buildMeasurementSnackbar(
        message: "Measurement removed",
        context: context,
        color: Theme.of(context).colorScheme.primary);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void _onAddMeasurementPressed() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddMeasurementDialog(
              onConfirmPressed: _confirmMeasurementAddition);
        });
  }

  void _onRemoveMeasurementPressed(String name) async {
    bool result = await _showConfirmMeasurementRemovalDialog();
    if (result) {
      _confirmMeasurementRemoval(name);
    }
  }

  Future<bool> _showConfirmMeasurementRemovalDialog() async {
    bool wantsToCancel = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Measurement?'),
          content: const Text(
              'Are you sure you want to remove this measurement? All data will be lost. This cannot be undone.'),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget>[
            FilledButton(
              child: Text('Remove Measurement'),
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
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('cancel'),
            ),
          ],
        );
      },
    );
    return wantsToCancel;
  }

  SnackBar _buildMeasurementSnackbar({
    required String message,
    required BuildContext context,
    required Color color,
  }) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4), // Add some spacing
        ],
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }

  Widget _buildAddMeasurementButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(350, 40), // NEW
      ),
      onPressed: () => _onAddMeasurementPressed(),
      child: const Text(
        '+',
        style: TextStyle(fontSize: Constants.fontSize5),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 120),
          child: Text(
            "Measurements",
            style: TextStyle(
                fontSize: Constants.fontSize5, fontWeight: FontWeight.w600),
          ),
        ),
        TextButton(
            onPressed: () => _onEditButtonPressed(),
            child: Text(_editIsActive ? 'Cancel' : "Edit")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopRow(),
        Column(
          children: [
            BlocBuilder<MeasurementsCubit, MeasurementsState>(
                builder: (context, state) {
              if (state is MeasurementsLoaded) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.measurements.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        horizontalTitleGap: 1,
                        title: Text(state.measurements[index].name),
                        trailing: _editIsActive
                            ? IconButton(
                                onPressed: () => _onRemoveMeasurementPressed(
                                    state.measurements[index].name),
                                icon: Icon(Icons.remove_circle))
                            : Icon(Icons.arrow_right),
                        onTap: _editIsActive
                            ? null
                            : () => _onMeasurementPressed(
                                state.measurements[index]),
                      );
                    });
              } else {
                return const CircularProgressIndicator(
                  semanticsLabel: "Loading",
                );
              }
            }),
            _editIsActive ? _buildAddMeasurementButton() : Container()
          ],
        ),
      ],
    );
  }
}
