import 'package:flutter/material.dart';

import '../../models/event.dart';
import 'event_cell.dart';

class DayCol extends StatelessWidget {
  const DayCol({required this.events, super.key});
  final List<Event> events;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          Column(children: List.generate(24, (_) => const EmptyCell())),
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
  const EmptyCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
      ),
    );
  }
}
