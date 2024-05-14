import 'package:calendar_view/src/models/event.dart';
import 'package:flutter/material.dart';

class EventCell extends StatelessWidget {
  const EventCell({super.key, required this.event, required this.pos});

  final Event event;
  final (double width, double indent) pos;

// #TODO: Drag all day event to another day
// #TODO: Drag all day event to a scheduled time

  @override
  Widget build(BuildContext context) {
    final (width, indent) = pos;
    return Positioned(
      top: event.top,
      left: indent,
      child: Column(
        children: [
          Draggable(
            feedback: const Text('Hello'),
            child: MouseRegion(
              cursor: SystemMouseCursors.grab,
              // onEnter: (event) => print('${event.down}'),
              child: SizedBox(
                width: width,
                height: event.duration,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(3.0, 2.0, 3.0, 0.0),
                  decoration: BoxDecoration(
                    color: Colors.amber[200],
                    border: Border.all(color: Colors.grey[500]!),
                    borderRadius:
                        const BorderRadius.all(Radius.elliptical(5.0, 7.5)),
                  ),
                  child: EventCellText(event.summary,
                      '${event.startTimeString} - ${event.endTimeString}',
                      duration: event.duration),
                ),
              ),
            ),
          ),
          Draggable(
              data: event,
              axis: Axis.vertical,
              feedback: Container(height: 0.5, width: width, color: Colors.red),
              // onDragStarted: () => print('onDragStarted'),
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpDown,
                // onEnter: (details) => print('onEnter: $details'),
                child: SizedBox(height: 3.0, width: width),
              )),
        ],
      ),
    );
  }
}

class EventCellText extends StatelessWidget {
  const EventCellText(this.line1, this.line2,
      {required this.duration, super.key});
  final String line1;
  final String line2;
  final double duration;
  @override
  Widget build(BuildContext context) {
    final factor = switch (duration) {
      <= 15 => 0.5,
      <= 30 => 1.0,
      <= 45 => 0.9,
      _ => 1.0
    };

    final string = '$line1${duration > 30.0 ? '\n$line2' : ''}';

    return Text(
      string,
      overflow: TextOverflow.fade,
      softWrap: false,
      textScaler: TextScaler.linear(factor),
    );
  }
}
