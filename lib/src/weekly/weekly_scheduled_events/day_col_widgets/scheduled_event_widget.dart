import 'package:flutter/material.dart';

import '../../../models/event_interface.dart';

class ScheduledEventWidget extends StatelessWidget {
  const ScheduledEventWidget({
    super.key,
    required this.width,
    required this.duration,
    required this.event,
  });

  final double width;
  final double duration;
  final CVEvent event;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: duration,
      child: Container(
        padding: duration > 15.0
            ? const EdgeInsets.fromLTRB(3.0, 2.0, 3.0, 2.0)
            : const EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 0.0),
        decoration: BoxDecoration(
          color: Color(event.color),
          border: Border.all(color: Colors.grey[500]!),
          borderRadius: const BorderRadius.all(Radius.elliptical(5.0, 7.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.summary.replaceAll('☐ ', '') != event.summary)
              Transform.scale(
                  scale: 0.75,
                  child: Checkbox(
                      value: false, tristate: true, onChanged: (_) {})),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.summary.replaceAll('☐ ', ''),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    textScaler: TextScaler.linear(factor(duration)),
                  ),
                  if (duration > 30.0)
                    Text(
                      '$startTimeString - $endTimeString',
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      textScaler: TextScaler.linear(factor(duration) * 0.8),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  double factor(double duration) => switch (duration) {
        <= 15 => 0.674,
        <= 30 => 1.0,
        <= 45 => 0.9,
        _ => 1.0
      };

  String get startTimeString =>
      '${event.start.hour.toString().padLeft(2, '0')}:${event.start.minute.toString().padLeft(2, '0')}';

  String get endTimeString =>
      '${event.end.hour.toString().padLeft(2, '0')}:${event.end.minute.toString().padLeft(2, '0')}';
}
