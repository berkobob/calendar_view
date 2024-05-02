import 'package:calendar_view/src/weekly/widgets/hour_labels.dart';
import 'package:flutter/material.dart';

import '../../models/event.dart';
import 'day_col.dart';

class WeeklyCalendar extends StatelessWidget {
  const WeeklyCalendar(this.events, {super.key});
  final List<List<Event>> events;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(flex: 1, child: HourLabels()),
            Expanded(flex: 2, child: DayCol(events: events[0])),
            Expanded(flex: 2, child: DayCol(events: events[1])),
            Expanded(flex: 2, child: DayCol(events: events[2])),
            Expanded(flex: 2, child: DayCol(events: events[3])),
            Expanded(flex: 2, child: DayCol(events: events[4])),
            Expanded(flex: 2, child: DayCol(events: events[5])),
            Expanded(flex: 2, child: DayCol(events: events[6])),
          ],
        ),
      ),
    );
  }
}
