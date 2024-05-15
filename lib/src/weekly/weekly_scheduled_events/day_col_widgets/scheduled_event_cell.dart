import 'package:calendar_view/src/models/models.dart';
import 'package:calendar_view/src/weekly/weekly_scheduled_events/day_col_widgets/scheduled_event_widget.dart';
import 'package:flutter/material.dart';

class ScheduledEventCell extends StatefulWidget {
  const ScheduledEventCell({super.key, required this.event, required this.pos});

  final ScheduledEvent event;
  final (double width, double indent) pos;

  @override
  State<ScheduledEventCell> createState() => _ScheduledEventCellState();
}

class _ScheduledEventCellState extends State<ScheduledEventCell> {
  late double duration;
  late String summary;

  @override
  void initState() {
    duration = widget.event.duration;
    summary = widget.event.summary;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ScheduledEventCell oldWidget) {
    duration = widget.event.duration;
    summary = widget.event.summary;
    super.didUpdateWidget(oldWidget);
  }

// #TODO: Drag all day event to another day
  @override
  Widget build(BuildContext context) {
    final (width, indent) = widget.pos;
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
                  width: width, duration: duration, event: widget.event),
            ),
            feedback: Material(
              child: ScheduledEventWidget(
                  width: width, duration: duration, event: widget.event),
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.grab,
              // onEnter: (event) => print('${event.down}'),
              child: ScheduledEventWidget(
                  width: width, duration: duration, event: widget.event),
            ),
          ),
          Draggable(
              data: widget.event,
              axis: Axis.vertical,
              feedback: Container(),
              // onDragStarted: () => print('onDragStarted'),
              onDragUpdate: (details) => setState(() {
                    // print(
                    //     'Delta: ${details.delta.dy} Global: ${details.globalPosition.dy} Local: ${details.localPosition.dy}');
                    // print(x);
                    setState(() => duration += details.delta.dy);
                  }),
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
