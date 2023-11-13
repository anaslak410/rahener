// ignore_for_file: public_member_api_docs, sort_constructors_first
class Measurement {
  final double value;
  final String name;
  final DateTime entryDate;
  Measurement({
    required this.value,
    required this.name,
    required this.entryDate,
  });

  Measurement copyWith({
    double? value,
    String? name,
    DateTime? entryDate,
  }) {
    return Measurement(
      value: value ?? this.value,
      name: name ?? this.name,
      entryDate: entryDate ?? this.entryDate,
    );
  }

  @override
  String toString() =>
      'Measurement(value: $value, name: $name, entryDate: $entryDate)';

  @override
  bool operator ==(covariant Measurement other) {
    if (identical(this, other)) return true;

    return other.value == value &&
        other.name == name &&
        other.entryDate == entryDate;
  }

  @override
  int get hashCode => value.hashCode ^ name.hashCode ^ entryDate.hashCode;
}
