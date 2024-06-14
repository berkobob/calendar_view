import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../controllers/weekly_controller.dart';
import '../../models/models.dart';

class WeeklyAllDayDropTarget extends StatelessWidget {
  const WeeklyAllDayDropTarget({super.key, this.child});
  final Widget? child;

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
          child: DragTarget<CVEvent>(
              builder: (context, _, __) {
                return Container(
                  decoration: BoxDecoration(
                    border: border[day],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: child,
                );
              },
              onLeave: (data) => border[day] = null,
              onWillAcceptWithDetails: (event) {
                if (event.data.isAllDay &&
                    event.data.start.weekday - 1 == day) {
                  return false;
                }
                border[day] = Border.all(color: Colors.pink, width: 2.0);
                return true;
              },
              onAcceptWithDetails: (item) {
                final CVEvent event = item.data;
                event.start = wc.monday.add(Duration(days: day));
                event.end = wc.monday.add(Duration(days: day + 1));
                event.isAllDay = true;
                wc.addEvent(event);
                border[day] = null;
              }),
        ),
      )
    ]);
  }
}
