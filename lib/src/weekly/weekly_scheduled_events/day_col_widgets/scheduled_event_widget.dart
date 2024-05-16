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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.event.summary.replaceAll('☐ ', '') != event.event.summary)
              Transform.scale(
                  scale: 0.75,
                  child: Checkbox(
                      value: false, tristate: true, onChanged: (_) {})),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.event.summary.replaceAll('☐ ', ''),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    textScaler: TextScaler.linear(factor(duration)),
                  ),
                  if (duration > 30.0)
                    Text(
                      '${event.startTimeString} - ${event.endTimeString}',
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

  double factor(double duration) =>
      switch (duration) { <= 15 => 0.45, <= 30 => 1.0, <= 45 => 0.9, _ => 1.0 };
}
