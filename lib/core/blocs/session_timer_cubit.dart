import 'package:bloc/bloc.dart';
import 'dart:async';

class SessionTimerCubit extends Cubit<Duration> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  SessionTimerCubit() : super(Duration.zero) {
    start();
  }

  void start() {
    _startTimer();
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
    } else {
      throw Exception("attempted to run stopwatch when it was already running");
    }
  }

  void stop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer?.cancel();
    }
  }

  void reset() {
    if (_stopwatch.isRunning) {
      stop();
    }
    _stopwatch.reset();
    emit(_stopwatch.elapsed);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_stopwatch.isRunning) {
        emit(_stopwatch.elapsed);
      } else {
        timer.cancel();
      }
    });
  }
}
