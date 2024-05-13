import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../controllers/weekly_controller.dart';

class AllDayEventDropTarget extends StatelessWidget {
  const AllDayEventDropTarget({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final addAllDayEvent = di.get<WeeklyController>().addAllDayEvent;
    final List<BoxBorder?> border = List.generate(7, (index) => null);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(flex: 1),
        ...List.generate(
            7,
            (day) => Expanded(
                flex: 2,
                child: DragTarget<String>(
                  builder: (context, _, __) {
                    return Container(
                      decoration: BoxDecoration(
                          border: border[day],
                          borderRadius: BorderRadius.circular(10.0)),
                    );
                  },
                  onLeave: (data) => border[day] = null,
                  onWillAcceptWithDetails: (task) {
                    border[day] =
                        Border.all(color: Theme.of(context).primaryColor);
                    return true;
                  },
                  onAcceptWithDetails: (task) {
                    border[day] = null;
                    final start = date.add(Duration(days: day));
                    addAllDayEvent(task: task.data, start: start);
                  },
                )))
      ],
    );
  }
}
