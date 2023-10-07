// ignore_for_file: public_member_api_docs, sort_constructors_first
class Measurement {
  double weight;
  String name;
  DateTime entryDate;
  Measurement({
    required this.weight,
    required this.name,
    required this.entryDate,
  });

  @override
  String toString() =>
      'Measurement(weight: $weight, name: $name, entryDate: $entryDate)';
}
