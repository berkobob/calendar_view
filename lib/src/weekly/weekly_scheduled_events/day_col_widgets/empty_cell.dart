import 'package:calendar_view/src/controllers/weekly_controller.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../models/event.dart';

class EmptyCell extends StatelessWidget {
  const EmptyCell(
      {super.key,
      required this.date,
      required this.hour,
      required this.start,
      required this.end});

  final int hour;
  final DateTime date;
  final int start;
  final int end;

  @override
  Widget build(BuildContext context) {
    final controller = di.get<WeeklyController>();
    Border? border = Border.all(color: Colors.grey[200]!);
    return DragTarget<Event>(
      onWillAcceptWithDetails: (_) {
        border = Border.all(color: Colors.pink, width: 2.0);
        return true;
      },
      onAcceptWithDetails: (task) {
        final dateTime = date.add(Duration(hours: hour));
        final s = start == 0 ? 60 : start;
        controller.addScheduledEvent(
            event: task.data,
            start: dateTime.add(Duration(minutes: end)),
            end: dateTime.add(Duration(minutes: s)));
        border = Border.all(color: Colors.pink, width: 2.0);
      },
      onLeave: (data) => border = Border.all(color: Colors.grey[200]!),
      builder: (context, _, __) => Container(
        height: 60.0,
        decoration: BoxDecoration(
          border: border,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
