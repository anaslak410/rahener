import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rahener/core/models/measurement.dart';
import 'package:rahener/utils/constants.dart';

class AddMeasurementDialog extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final Function onConfirmPressed;
  final _formKey = GlobalKey<FormState>();

  AddMeasurementDialog({super.key, required this.onConfirmPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  counterText: '', labelText: "Name", filled: true),
              validator: (value) {
                if (value == "") {
                  return 'Please enter a name';
                }
                return null;
              },
              maxLength: 30,
              controller: nameController,
            ),
            const SizedBox(
              height: Constants.margin4,
            ),
            TextFormField(
              controller: unitController,
              maxLength: 5,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.deny(RegExp('[0-9]')),
              ],
              validator: (value) {
                if (value == "") {
                  return 'Please enter a unit';
                }
                return null;
              },
              decoration: const InputDecoration(
                  counterText: '', labelText: "Unit", filled: true),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Measurement measurement = Measurement(
                  name: nameController.text, unit: unitController.text);
              onConfirmPressed(measurement);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
