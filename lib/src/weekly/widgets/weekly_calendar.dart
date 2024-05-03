import 'dart:async';

import 'package:calendar_view/src/weekly/widgets/hour_labels.dart';
import 'package:flutter/material.dart';

import '../../models/event.dart';
import 'day_col.dart';

class WeeklyCalendar extends StatefulWidget {
  const WeeklyCalendar(this.events, {required this.showTimeLine, super.key});
  final List<List<Event>> events;
  final bool showTimeLine;

  @override
  State<WeeklyCalendar> createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  late final ScrollController controller;
  late final Timer timer;
  double offset = 0.0;

  @override
  void initState() {
    super.initState();
    offset = (DateTime.now().hour * 60 + DateTime.now().minute).toDouble();
    controller =
        ScrollController(initialScrollOffset: offset, keepScrollOffset: true);

    timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() => offset =
          (DateTime.now().hour * 60 + DateTime.now().minute).toDouble());
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    timer.cancel();
  }

  @override
  void didUpdateWidget(covariant WeeklyCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    offset = (DateTime.now().hour * 60 + DateTime.now().minute).toDouble();
    controller.animateTo(offset,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: controller,
        child: CustomPaint(
          painter: widget.showTimeLine ? LinePainter(offset: offset) : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(flex: 1, child: HourLabels()),
              Expanded(flex: 2, child: DayCol(events: widget.events[0])),
              Expanded(flex: 2, child: DayCol(events: widget.events[1])),
              Expanded(flex: 2, child: DayCol(events: widget.events[2])),
              Expanded(flex: 2, child: DayCol(events: widget.events[3])),
              Expanded(flex: 2, child: DayCol(events: widget.events[4])),
              Expanded(flex: 2, child: DayCol(events: widget.events[5])),
              Expanded(flex: 2, child: DayCol(events: widget.events[6])),
            ],
          ),
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final double offset;
  LinePainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1.0;
    canvas.drawLine(
        Offset(size.width / 15, offset), Offset(size.width, offset), paint);
    canvas.drawCircle(Offset(size.width / 15, offset), 5.0, paint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) => oldDelegate.offset != offset;
}
