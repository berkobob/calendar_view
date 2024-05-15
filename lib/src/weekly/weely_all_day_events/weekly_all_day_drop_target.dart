import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:week_of_year/date_week_extensions.dart';

import '../../controllers/weekly_controller.dart';
import '../../models/event.dart';

class WeeklyAllDayDropTarget extends StatelessWidget {
  const WeeklyAllDayDropTarget({super.key});

  @override
  Widget build(BuildContext context) {
    final wc = di.get<WeeklyController>();
    final List<BoxBorder?> border = List.generate(7, (index) => null);

    return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const Spacer(flex: 1),
      ...List.generate(
        7,
        (day) => Expanded(
          flex: 2,
          child: DragTarget<Object>(
              // #TODO: Don't accept task from this date
              builder: (context, _, __) {
                return Container(
                  decoration: BoxDecoration(
                    border: border[day],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                );
              },
              onLeave: (data) => border[day] = null,
              onWillAcceptWithDetails: (task) {
                if (task.data is Event) {
                  final event = task.data as Event;
                  if (event.isAllDay && event.start.weekOfYear == day) {
                    return false;
                  }
                }
                if (task.data is Event || task.data is String) {
                  border[day] =
                      Border.all(color: Theme.of(context).primaryColor);
                  return true;
                }
                return false;
              },
              onAcceptWithDetails: (task) {
                final event = task.data is Event
                    ? task.data as Event
                    : Event(
                        summary: task.data as String,
                        start: wc.monday.value.add(Duration(days: day)),
                        end: wc.monday.value.add(Duration(days: day + 1)),
                        isAllDay: true,
                      );
                border[day] = null;
                event.start = wc.monday.value.add(Duration(days: day));
                event.end = wc.monday.value.add(Duration(days: day + 1));
                event.isAllDay = true;
                wc.addAllDayEvent(event: event);
              }),
        ),
      )
    ]);
  }
}
