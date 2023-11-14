import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahener/core/repositories/sessions_repository.dart';

class ExerciseProgressCubit extends Cubit<ExerciseProgressState> {
  SessionsRepository _repository;
  ExerciseProgressCubit(this._repository) : super(ExerciseProgressState());
}

class ExerciseProgressState {}
