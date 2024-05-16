import 'package:calendar_view/src/weekly/weekly_scheduled_events/day_col_widgets/empty_cell.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../controllers/weekly_controller.dart';
import '../../../models/models.dart';
import 'scheduled_event_cell.dart';

class DayCol extends StatelessWidget with WatchItMixin {
  const DayCol({required this.day, super.key});
  final int day;

  @override
  Widget build(BuildContext context) {
    final date = di.get<WeeklyController>().monday.add(Duration(days: day));
    final events = watchPropertyValue<WeeklyController, List<ScheduledEvent>>(
        (controller) => controller.scheduledEvents[date.weekday - 1]);
    watchPropertyValue<WeeklyController, int>(
        (controller) => controller.scheduledEvents[date.weekday - 1].length);
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          Column(
              children: List.generate(24, (hour) {
            final start = events
                .where((event) => event.start.hour == hour)
                .fold<int>(
                    0,
                    (int start, ScheduledEvent event) =>
                        event.start.minute > start
                            ? event.start.minute
                            : start);

            final end = events.where((event) => event.end.hour == hour).fold(
                0,
                (int end, ScheduledEvent event) =>
                    event.end.minute > end ? event.end.minute : end);

            return EmptyCell(date: date, hour: hour, start: start, end: end);
          })),
          ...drawEvents(width: constraints.maxWidth, events: events)
        ],
      ),
    );
  }

  List<Widget> drawEvents(
      {required double width, required List<ScheduledEvent> events}) {
    List<Widget> widgets = [];
    bool overlap = false;
    bool nextdoor = false;

    for (final (i, event) in events.indexed) {
      if (i < events.length - 1) {
        final next = events[i + 1];

        if (overlap) {
          widgets
              .add(ScheduledEventCell(event: event, pos: (width - 20.0, 20.0)));
        } else if (nextdoor) {
          widgets.add(
              ScheduledEventCell(event: event, pos: (width / 2, width / 2)));
        } else {
          widgets.add(ScheduledEventCell(event: event, pos: (width, 0.0)));
        }

        if (event.end.compareTo(next.start) > 0 &&
            event.start.compareTo(next.start) < 0) {
          overlap = true;
        } else {
          overlap = false;
        }

        if (event.start.hour == next.start.hour &&
            event.start.minute == next.start.minute) {
          nextdoor = true;
        } else {
          nextdoor = false;
        }
      } else {
        if (nextdoor) {
          widgets.add(
              ScheduledEventCell(event: event, pos: (width / 2, width / 2)));
        } else if (overlap) {
          widgets
              .add(ScheduledEventCell(event: event, pos: (width - 20.0, 20.0)));
        } else {
          widgets.add(ScheduledEventCell(event: event, pos: (width, 0.0)));
        }
      }
    }
    return widgets;
  }
}
