import 'package:calendar_view/src/models/event.dart';
import 'package:flutter/material.dart';

class EventCell extends StatefulWidget {
  const EventCell({super.key, required this.event, required this.pos});

  final Event event;
  final (double width, double indent) pos;

  @override
  State<EventCell> createState() => _EventCellState();
}

class _EventCellState extends State<EventCell> {
  late double duration;
  late String summary;

  @override
  void initState() {
    duration = widget.event.duration;
    summary = widget.event.summary;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EventCell oldWidget) {
    print('${oldWidget.event.summary} BECOMING ${widget.event.summary}');
    duration = widget.event.duration;
    summary = widget.event.summary;
    super.didUpdateWidget(oldWidget);
  }

// #TODO: Drag all day event to another day
  @override
  Widget build(BuildContext context) {
    final (width, indent) = widget.pos;
    return Positioned(
      top: widget.event.top,
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
                height: duration,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(3.0, 2.0, 3.0, 2.0),
                  decoration: BoxDecoration(
                    color: Colors.amber[200],
                    border: Border.all(color: Colors.grey[500]!),
                    borderRadius:
                        const BorderRadius.all(Radius.elliptical(5.0, 7.5)),
                  ),
                  child: EventCellText(widget.event.summary,
                      '${widget.event.startTimeString} - ${widget.event.endTimeString}',
                      duration: widget.event.duration),
                ),
              ),
            ),
          ),
          Draggable(
              data: widget.event,
              axis: Axis.vertical,
              feedback: Container(height: 0.5, width: width, color: Colors.red),
              // onDragStarted: () => print('onDragStarted'),
              onDragUpdate: (details) => setState(() {
                    print(details.delta.dy);
                    duration += details.delta.dy;
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
