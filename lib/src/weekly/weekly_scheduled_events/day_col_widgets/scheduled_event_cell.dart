import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../controllers/weekly_controller.dart';
import '../../../models/models.dart';
import 'scheduled_event_widget.dart';

class ScheduledEventCell extends StatefulWidget {
  const ScheduledEventCell({super.key, required this.event, required this.pos});

  final ScheduledEvent event;
  final (double width, double indent) pos;

  @override
  State<ScheduledEventCell> createState() => _ScheduledEventCellState();
}

class _ScheduledEventCellState extends State<ScheduledEventCell> {
  late double duration;

  @override
  void initState() {
    duration = widget.event.duration;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ScheduledEventCell oldWidget) {
    duration = widget.event.duration;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final (width, indent) = widget.pos;
    duration = duration >= 5.0 ? duration : 5.0;
    return Positioned(
      top: widget.event.startTimeInMinutes,
      left: indent,
      child: Column(
        children: [
          Draggable<Event>(
            data: widget.event.event,
            childWhenDragging: Opacity(
              opacity: 0.5,
              child: ScheduledEventWidget(
                width: width,
                duration: duration,
                event: widget.event,
              ),
            ),
            feedback: Material(
              child: ScheduledEventWidget(
                width: width,
                duration: duration,
                event: widget.event,
              ),
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.grab,
              // onEnter: (event) => debugPrint('${widget.event.event}'),
              child: ScheduledEventWidget(
                width: width,
                duration: duration,
                event: widget.event,
              ),
            ),
          ),
          Draggable(
            data: widget.event,
            axis: Axis.vertical,
            feedback: Container(),
            onDragEnd: (_) {
              di
                  .get<WeeklyController>()
                  .setDuration(widget.event.event, duration: duration);
              setState(() {});
            },
            onDragUpdate: (details) {
              duration += details.delta.dy;
              if (duration >= 5.0) setState(() {});
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeUpDown,
              child: SizedBox(height: 3.0, width: width),
            ),
          ),
        ],
      ),
    );
  }
}
