import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahener/core/blocs/ExerciseSet.dart';
import 'package:rahener/core/blocs/current_session_cubit.dart';
import 'package:rahener/core/blocs/current_session_state.dart';
import 'package:rahener/core/blocs/session_timer_cubit.dart';
import 'package:rahener/core/blocs/sessions_cubit.dart';
import 'package:rahener/core/models/exercise.dart';
import 'package:rahener/core/models/session.dart';
import 'package:rahener/core/screens/Sessions/currentSessionSheet.dart';
import 'package:rahener/utils/constants.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  void _onStartSessionTapped(timerCubit, sessionBloc) {
    setState(() {
      sessionBloc.startSession();
      timerCubit.reset();
      timerCubit.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentSessionBloc = BlocProvider.of<CurrentSessionCubit>(context);
    var timerCubit = BlocProvider.of<SessionTimerCubit>(context);
    // var sessionsCubit = BlocProvider.of<SessionsCubit>(context);
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
                    child: Text("Start Session"),
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
                        return SessionCard(session: state.sessions[index]);
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

class SessionCard extends StatelessWidget {
  final Session session;
  const SessionCard({Key? key, required this.session}) : super(key: key);

  double _calculateTotalWeight(Session session) {
    double totalWeight = 0.0;
    for (var exercise in session.exercisesPerfomed) {
      for (var set in exercise.sets) {
        totalWeight += set.weight;
      }
    }
    return totalWeight;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        left: Constants.sideMargin,
        right: Constants.sideMargin,
        bottom: Constants.margin4,
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 4.0),
                    Text(
                        '${session.datePerformed.year}-${session.datePerformed.month}-${session.datePerformed.day}'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time),
                    SizedBox(width: 4.0),
                    Text(
                        '${session.duration.inHours}:${session.duration.inMinutes.remainder(60)}:${(session.duration.inSeconds.remainder(60))}'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.fitness_center),
                    SizedBox(width: 4.0),
                    Text('${_calculateTotalWeight(session)} kg'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: Constants.margin6),
            for (SessionExercise exercise in session.exercisesPerfomed)
              Container(
                margin: EdgeInsets.only(bottom: Constants.margin4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        '${exercise.name}',
                        style: TextStyle(
                            fontSize: Constants.fontSize5,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < exercise.sets.length; i++)
                            Text(
                              '${exercise.sets[i].reps} x ${exercise.sets[i].weight}',
                              style: TextStyle(fontSize: Constants.fontSize4),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
