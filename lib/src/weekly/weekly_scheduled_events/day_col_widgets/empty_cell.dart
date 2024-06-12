import 'package:calendar_view/src/controllers/weekly_controller.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../models/models.dart';

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
    final wc = di.get<WeeklyController>();
    Border? border = Border.all(color: Colors.grey[200]!);
    return DragTarget<CVEvent>(
      onWillAcceptWithDetails: (item) {
        final event = item.data;
        if (event.isAllDay &&
            event.end.difference(event.start).inDays.abs() > 1) {
          return false;
        }
        border = Border.all(color: Colors.pink, width: 2.0);
        return true;
      },
      onAcceptWithDetails: (item) {
        final CVEvent event = item.data;
        final dateTime = date.add(Duration(hours: hour));
        final duration = !event.isAllDay
            ? item.data.end.difference(item.data.start).inMinutes.abs()
            : start == 0
                ? 60
                : start;

        event.start = dateTime;
        event.end = dateTime.add(Duration(minutes: duration));
        event.isAllDay = false;
        // Event event = item.data.copyWith(
        //     start: dateTime,
        //     end: dateTime.add(Duration(minutes: duration)),
        //     isAllDay: false);
        wc.addEvent(event);
        border = Border.all(color: Colors.pink, width: 2.0);
      },
      onLeave: (data) => border = Border.all(color: Colors.grey[200]!),
      builder: (context, _, __) => Container(
        height: 60.0,
        decoration: BoxDecoration(
          border: border,
        ),
      ),
    );
  }
}
