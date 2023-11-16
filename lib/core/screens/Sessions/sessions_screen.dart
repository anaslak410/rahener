import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahener/core/blocs/current_session_cubit.dart';
import 'package:rahener/core/blocs/current_session_state.dart';
import 'package:rahener/core/blocs/session_timer_cubit.dart';
import 'package:rahener/core/blocs/sessions_cubit.dart';
import 'package:rahener/core/models/session.dart';
import 'package:rahener/core/screens/sessions/current_session_sheet.dart';
import 'package:rahener/core/screens/sessions/session_card.dart';
import 'package:rahener/utils/constants.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  late final SessionsCubit _sessionsCubit;

  @override
  void initState() {
    _sessionsCubit = BlocProvider.of<SessionsCubit>(context);
    super.initState();
  }

  void _onStartSessionTapped(timerCubit, sessionBloc) {
    setState(() {
      sessionBloc.startSession();
      timerCubit.reset();
      timerCubit.start();
    });
  }

  void _onDeleteSessionTapped(Session session) async {
    bool result = await _showSessionDeleteConfirmationDialog();
    if (result) {
      _sessionsCubit.removeSession(session);
    }
  }

  Future<bool> _showSessionDeleteConfirmationDialog() async {
    bool wantsToCancel = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Session?'),
          content: Text(
              'Are you sure you want to delete this session? It is not possible to restore it afterwards.'),
          actions: <Widget>[
            FilledButton(
              child: Text('Delete Session'),
              onPressed: () {
                wantsToCancel = true;
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Constants.borderRadius),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
    return wantsToCancel;
  }

  @override
  Widget build(BuildContext context) {
    var currentSessionBloc = BlocProvider.of<CurrentSessionCubit>(context);
    var timerCubit = BlocProvider.of<SessionTimerCubit>(context);
    return Scaffold(
      floatingActionButton:
          BlocBuilder<CurrentSessionCubit, CurrentSessionState>(
        builder: (context, state) {
          return currentSessionBloc.state.isInProgress
              ? Container()
              : SizedBox(
                  width: 400,
                  child: FloatingActionButton(
                    onPressed: () =>
                        _onStartSessionTapped(timerCubit, currentSessionBloc),
                    child: const Text("Start Session"),
                  ));
        },
      ),
      appBar: AppBar(
        title: const Text('Exercise Sessions'),
      ),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          BlocBuilder<SessionsCubit, SessionsState>(
            builder: (context, state) {
              return state.sessions.isNotEmpty
                  ? ListView.builder(
                      itemCount: state.sessions.length,
                      itemBuilder: (context, index) {
                        return SessionCard(
                          session: state.sessions[index],
                          onDelete: _onDeleteSessionTapped,
                        );
                      },
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fitness_center,
                            size: 64.0,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'No sessions done yet',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
              ;
            },
          ),
          const CurrentSessionSheet()
        ],
      ),
    );
  }
}
