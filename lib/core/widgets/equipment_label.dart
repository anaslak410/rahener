import 'package:flutter/material.dart';
import 'package:rahener/utils/constants.dart';

class EquipmentLabel extends StatelessWidget {
  final String equipment;
  const EquipmentLabel({super.key, required this.equipment});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomRight,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 50, maxWidth: 100),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(Constants.borderRadius),
          ),
          child: Text(
            equipment,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              // decoration: TextDecoration(,
            ),
          ),
        ));
  }
}
