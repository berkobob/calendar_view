import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../controllers/weekly_controller.dart';
import '../../models/event.dart';
import 'event_cell.dart';

class DayCol extends StatelessWidget with WatchItMixin {
  const DayCol({required this.date, super.key});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final events = watchPropertyValue<WeeklyController, List<Event>>(
        (controller) => controller.events[date.weekday - 1]);
    watchPropertyValue<WeeklyController, int>(
        (controller) => controller.events[date.weekday - 1].length);
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          Column(
              children: List.generate(24, (hour) {
            final start = events
                .where((event) => event.start.hour == hour)
                .fold<int>(
                    0,
                    (int start, Event event) => event.start.minute > start
                        ? event.start.minute
                        : start);

            final end = events.where((event) => event.end.hour == hour).fold(
                0,
                (int end, Event event) =>
                    event.end.minute > end ? event.end.minute : end);

            return EmptyCell(date: date, hour: hour, start: start, end: end);
          })),
          ...drawEvents(width: constraints.maxWidth, events: events)
        ],
      ),
    );
  }

  List<Widget> drawEvents(
      {required double width, required List<Event> events}) {
    List<Widget> widgets = [];
    bool overlap = false;
    bool nextdoor = false;

    for (final (i, event) in events.indexed) {
      if (i < events.length - 1) {
        final next = events[i + 1];

        if (overlap) {
          widgets.add(EventCell(event: event, pos: (width - 20.0, 20.0)));
        } else if (nextdoor) {
          widgets.add(EventCell(event: event, pos: (width / 2, width / 2)));
        } else {
          widgets.add(EventCell(event: event, pos: (width, 0.0)));
        }

        if (event.end.compareTo(next.start) > 0) {
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
          widgets.add(EventCell(event: event, pos: (width / 2, width / 2)));
        } else if (overlap) {
          widgets.add(EventCell(event: event, pos: (width - 20.0, 20.0)));
        } else {
          widgets.add(EventCell(event: event, pos: (width, 0.0)));
        }
      }
    }
    return widgets;
  }
}

class EmptyCell extends StatelessWidget {
  const EmptyCell(
      {super.key,
      required this.date,
      required this.hour,
      required this.start,
      required this.end});

// #TODO: this can be simplified
  final int hour;
  final DateTime date;
  final int start;
  final int end;

  @override
  Widget build(BuildContext context) {
    final controller = di.get<WeeklyController>();
    Border? border = Border.all(color: Colors.grey[200]!);
    return DragTarget<String>(
      onWillAcceptWithDetails: (_) {
        border = Border.all(color: Colors.pink, width: 2.0);
        return true;
      },
      onAcceptWithDetails: (task) {
        final dateTime = date.add(Duration(hours: hour));
        final s = start == 0 ? 60 : start;
        controller.addEvent(
            task: task.data,
            start: dateTime.add(Duration(minutes: end)),
            end: dateTime.add(Duration(minutes: s)));
        border = Border.all(color: Colors.pink, width: 2.0);
      },
      onLeave: (data) => border = Border.all(color: Colors.grey[200]!),
      builder: (context, _, __) => Container(
        height: 60.0,
        decoration: BoxDecoration(
            border: border, borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}
