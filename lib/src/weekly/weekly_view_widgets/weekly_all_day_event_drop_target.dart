import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../controllers/weekly_controller.dart';

class WeeklyAllDayEventDropTarget extends StatelessWidget {
  const WeeklyAllDayEventDropTarget({super.key});

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
          child: DragTarget<String>(
              // #TODO: Replace with Task
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
                border[day] = Border.all(color: Theme.of(context).primaryColor);
                return true;
              },
              onAcceptWithDetails: (task) {
                border[day] = null;
                final start = wc.monday.value.add(Duration(days: day));
                wc.addAllDayEvent(task: task.data, start: start);
              }),
        ),
      )
    ]);
  }
}
