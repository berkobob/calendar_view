import 'package:calendar_view/src/models/event.dart';
import 'package:flutter/material.dart';

class EventCell extends StatelessWidget {
  const EventCell({super.key, required this.event, required this.pos});

  final Event event;
  final (double width, double indent) pos;

  @override
  Widget build(BuildContext context) {
    final (width, indent) = pos;
    return Positioned(
      top: event.start.hour * 60.0 + event.start.minute,
      left: indent,
      child: SizedBox(
        width: width,
        child: Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border.all(color: Colors.grey[500]!),
            borderRadius: const BorderRadius.all(Radius.elliptical(5.0, 7.5)),
          ),
          height: event.duration,
          child: FittedBox(
            alignment: Alignment.topLeft,
            fit: BoxFit.scaleDown,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.summary),
                if (event.duration > 15.0)
                  Text('${event.startTimeString} - ${event.endTimeString}')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
