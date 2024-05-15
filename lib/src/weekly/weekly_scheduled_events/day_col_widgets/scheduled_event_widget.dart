import 'package:flutter/material.dart';

import '../../../models/scheduled_event.dart';

class ScheduledEventWidget extends StatelessWidget {
  const ScheduledEventWidget({
    super.key,
    required this.width,
    required this.duration,
    required this.event,
  });

  final double width;
  final double duration;
  final ScheduledEvent event;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: duration,
      child: Container(
        padding: const EdgeInsets.fromLTRB(3.0, 2.0, 3.0, 2.0),
        decoration: BoxDecoration(
          color: Colors.amber[200],
          border: Border.all(color: Colors.grey[500]!),
          borderRadius: const BorderRadius.all(Radius.elliptical(5.0, 7.5)),
        ),
        child: EventCellText(event.event.summary,
            '${event.startTimeString} - ${event.endTimeString}',
            duration: event.duration),
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
