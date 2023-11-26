// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Measurement {
  final String name;
  final String unit;

  Measurement({
    required this.name,
    required this.unit,
  });

  Measurement copyWith({
    String? name,
    String? unit,
  }) {
    return Measurement(
      name: name ?? this.name,
      unit: unit ?? this.unit,
    );
  }

  @override
  String toString() => 'Measurement(name: $name, unit: $unit)';
}
