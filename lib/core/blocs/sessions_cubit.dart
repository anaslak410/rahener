// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rahener/core/models/session.dart';
import 'package:rahener/core/repositories/sessions_repository.dart';

class SessionsCubit extends Cubit<SessionsState> {
  SessionsRepository _repository;
  SessionsCubit(this._repository) : super(SessionsState(sessions: []));

  void addSession(Session session) {
    emit(state.copyWith(sessions: [session, ...state.sessions]));
  }

  void removeSession(Session session) {
    List<Session> newSessions = List.from(state.sessions);
    newSessions.remove(session);
    emit(state.copyWith(sessions: newSessions));
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
