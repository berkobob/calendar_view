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
    return DragTarget<Task>(
      onWillAcceptWithDetails: (task) {
        if (task.data case CVEvent event) {
          if (event.isAllDay &&
              event.end.difference(event.start).inDays.abs() > 1) {
            return false;
          }
        }
        border = Border.all(color: Colors.pink, width: 2.0);
        return true;
      },
      onAcceptWithDetails: (task) {
        CVEvent? was = task.data is CVEvent ? task.data as CVEvent : null;
        final dateTime = date.add(Duration(hours: hour));
        final duration = was != null && !was.isAllDay
            ? was.end.difference(was.start).inMinutes.abs()
            : start == 0
                ? 60
                : start;

        Map<String, dynamic> json =
            was != null ? was.toMap : {'summary': '☐ ${task.data.summary}'};

        json['start'] = dateTime;
        json['end'] = json['start'].add(Duration(minutes: duration));
        json['isAllDay'] = false;
        json['calendar'] = 'Default calendar';
        wc.addEvent(was: was, newEvent: CVEvent.fromMap(json));
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
