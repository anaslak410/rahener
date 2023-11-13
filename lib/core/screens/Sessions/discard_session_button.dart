import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rahener/utils/constants.dart';

class DiscardSessionButton extends StatelessWidget {
  final Function _onPress;
  const DiscardSessionButton({super.key, required Function onPress})
      : _onPress = onPress;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      child: Text('Discard'),
      onPressed: () {
        _onPress();
      },
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
        ),
      ),
    );
  }
}
