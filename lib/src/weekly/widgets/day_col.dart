import 'package:flutter/material.dart';

import '../../models/event.dart';
import 'event_cell.dart';

class DayCol extends StatelessWidget {
  const DayCol({required this.events, required this.day, super.key});
  final List<Event> events;
  final int day;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          Column(
              children: List.generate(24, (index) {
            final busy = events.where((event) =>
                event.start.hour == index ||
                event.end.hour == index ||
                (event.start.hour < index && event.end.hour > index));
            debugPrint(
                'Day $day: $index:00 is ${busy.isEmpty ? '' : 'not'} free');
            return EmptyCell(day: day, hour: index, free: busy.isEmpty);
          })),
          ...drawEvents(constraints.maxWidth)
        ],
      ),
    );
  }

  List<Widget> drawEvents(double width) {
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
      {super.key, required this.day, required this.free, required this.hour});
  final int hour;
  final int day;
  final bool free;

  @override
  Widget build(BuildContext context) {
    Border? border = Border.all(color: Colors.grey[200]!);
    return DragTarget<String>(
      onWillAcceptWithDetails: (_) {
        border = free
            ? Border.all(color: Colors.pink, width: 2.0)
            : Border.all(color: Colors.black, width: 1.0);
        return free;
      },
      onAcceptWithDetails: (task) {
        debugPrint('Cell accepts ${task.data} at $hour:00 on day $day');
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
