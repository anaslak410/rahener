import 'package:flutter/material.dart';
import 'package:rahener/utils/constants.dart';

class FinishSessionButton extends StatelessWidget {
  final Function _onPressed;
  const FinishSessionButton({super.key, required Function onPressed})
      : _onPressed = onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
        ),
      ),
      onPressed: () => _onPressed(),
      child: Text('Finish'),
    );
  }
}
