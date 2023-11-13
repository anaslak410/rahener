import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rahener/core/models/exercise.dart';
import 'package:rahener/core/models/session.dart';
import 'package:rahener/utils/constants.dart';

class SessionCard extends StatelessWidget {
  final Session session;
  final Function onDelete;
  const SessionCard({Key? key, required this.session, required this.onDelete})
      : super(key: key);

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
      margin: const EdgeInsets.only(
        left: Constants.sideMargin,
        right: Constants.sideMargin,
        bottom: Constants.margin4,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 8, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              iconSize: 20,
              onPressed: () => onDelete(session),
              icon: Icon(Icons.delete,
                  color: Theme.of(context).colorScheme.error),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 4.0),
                    Text(
                        '${session.datePerformed.year}-${session.datePerformed.month}-${session.datePerformed.day}'),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 4.0),
                    Text(
                        '${session.duration.inHours}:${session.duration.inMinutes.remainder(60)}:${(session.duration.inSeconds.remainder(60))}'),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.fitness_center),
                    const SizedBox(width: 4.0),
                    Text('${_calculateTotalWeight(session)} kg'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: Constants.margin6),
            for (SessionExercise exercise in session.exercisesPerfomed)
              Container(
                margin: const EdgeInsets.only(bottom: Constants.margin4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        exercise.name,
                        style: const TextStyle(
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
                              style: const TextStyle(
                                  fontSize: Constants.fontSize4),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            // height: 30,
            // width: 30,
            // margin: EdgeInsets.only(left: 340),
          ],
        ),
      ),
    );
  }
}
