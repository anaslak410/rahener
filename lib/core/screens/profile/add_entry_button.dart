import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rahener/utils/constants.dart';

class AddEntryButton extends StatefulWidget {
  final Function onPressed;
  const AddEntryButton({super.key, required this.onPressed});

  @override
  State<AddEntryButton> createState() => _AddEntryButtonState();
}

class _AddEntryButtonState extends State<AddEntryButton> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        onChanged: (value) {
          setState(() {});
        },
        maxLength: Constants.maxMeasurementEntry,
        keyboardType: TextInputType.number,
        controller: controller,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
        ],
        decoration: const InputDecoration(
            hintText: 'Add new entry', filled: true, counterText: ""),
      ),
      trailing: SizedBox(
        child: ElevatedButton(
          onPressed: controller.text.isEmpty
              ? null
              : () {
                  widget.onPressed(controller.text);
                  controller.clear();
                },
          child: const Icon(
            Icons.add,
            size: 15,
          ),
        ),
      ),
    );
  }
}
