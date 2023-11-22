class ExerciseSet {
  int _reps;
  double _weight;

  ExerciseSet({
    required reps,
    required weight,
  })  : _reps = reps,
        _weight = weight;

  int get reps {
    return _reps;
  }

  double get weight {
    return _weight;
  }

  set weight(double weight) {
    _weight = weight;
  }

  set reps(int reps) {
    _reps = reps;
  }

  @override
  String toString() => 'ExerciseSet(_reps: $_reps, _weight: $_weight)';
}
