import 'dart:async';

import 'package:rahener/core/models/session.dart';
import 'package:rahener/core/services/local_data.dart';
import 'package:rahener/utils/constants.dart';

class SessionsRepository {
  final LocalDataService _localJsonDataService;
  final _controller = StreamController<List<Session>>.broadcast();
  Stream<List<Session>> get listen => _controller.stream;
  final List<Session> _sessions = Constants.testSessions;

  static Future<SessionsRepository> create(
      {required LocalDataService localDataService}) async {
    var sessionsRepository =
        SessionsRepository._create(localJsonDataService: localDataService);

    return sessionsRepository;
  }

  List<Session> get sessions {
    return _sessions;
  }

  SessionsRepository._create({required LocalDataService localJsonDataService})
      : _localJsonDataService = localJsonDataService;

  void addSession(Session session) {
    _sessions.add(session);
    _controller.sink.add(_sessions);
  }

  void removeSession(Session session) {
    _sessions.remove(session);
    _controller.sink.add(_sessions);
  }
}
