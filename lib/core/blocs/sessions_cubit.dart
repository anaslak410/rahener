// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rahener/core/models/session.dart';
import 'package:rahener/core/repositories/sessions_repository.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final SessionsRepository _repository;
  SessionsCubit(this._repository) : super(SessionsState(sessions: [])) {
    _subscribe();
  }

  void _subscribe() {
    _repository.listen.listen(
      (items) {
        emit(state.copyWith(sessions: items));
      },
      onError: (error) => log(error),
    );
  }

  void addSession(Session session) {
    _repository.addSession(session);
  }

  void removeSession(Session session) {
    _repository.removeSession(session);
    // List<Session> newSessions = List.from(state.sessions);
    // newSessions.remove(session);
  }
}

class SessionsState {
  List<Session> sessions = [];
  SessionsState({
    required this.sessions,
  });

  SessionsState copyWith({
    List<Session>? sessions,
  }) {
    return SessionsState(
      sessions: sessions ?? this.sessions,
    );
  }
}
