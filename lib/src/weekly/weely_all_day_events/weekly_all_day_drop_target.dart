import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:week_of_year/date_week_extensions.dart';

import '../../controllers/weekly_controller.dart';
import '../../models/models.dart';

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
          child: DragTarget<Task>(
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
                  if (event.isAllDay && event.start.weekday - 1 == day) {
                    return false;
                  }
                }
                border[day] = Border.all(color: Theme.of(context).primaryColor);
                return true;
              },
              onAcceptWithDetails: (task) {
                Event? was = task.data is Event ? task.data as Event : null;

                Map<String, dynamic> json =
                    was != null ? was.toMap : {'summary': task.data.summary};

                json['start'] = wc.monday.value.add(Duration(days: day));
                json['end'] = wc.monday.value.add(Duration(days: day + 1));
                json['isAllDay'] = true;
                json['calendar'] = 'Default calendar';
                wc.addEvent(was: was, newEvent: Event.fromMap(json));
                border[day] = null;
              }),
        ),
      )
    ]);
  }
}
