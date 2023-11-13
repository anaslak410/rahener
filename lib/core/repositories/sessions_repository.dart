import 'package:rahener/core/models/session.dart';
import 'package:rahener/core/services/local_data.dart';

class SessionsRepository {
  final LocalDataService _localJsonDataService;

  final List<Session> _sessions = [];

  SessionsRepository._create({required LocalDataService localJsonDataService})
      : _localJsonDataService = localJsonDataService;

  void addSession(Session session) {
    _sessions.add(session);
  }

  void removeSession(Session session) {
    _sessions.remove(session);
  }

  List<Session> get sessions {
    return _sessions;
  }

  static Future<SessionsRepository> create(
      {required LocalDataService localDataService}) async {
    var sessionsRepository =
        SessionsRepository._create(localJsonDataService: localDataService);

    return sessionsRepository;
  }
}
