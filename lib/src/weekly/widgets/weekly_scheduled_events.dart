import 'dart:async';

import 'package:flutter/material.dart';

import 'day_col.dart';
import 'hour_labels.dart';
import 'time_line_painter.dart';

class WeeklyScheduledEvents extends StatefulWidget {
  const WeeklyScheduledEvents(this.date,
      {required this.showTimeLine, super.key});
  final DateTime date;
  final bool showTimeLine;

  @override
  State<WeeklyScheduledEvents> createState() => _WeeklyScheduledEventsState();
}

class _WeeklyScheduledEventsState extends State<WeeklyScheduledEvents> {
  late final ScrollController scrollController;
  late final Timer timer;

  @override
  void initState() {
    super.initState();
    scrollController =
        ScrollController(initialScrollOffset: offset, keepScrollOffset: true);
    timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() => scrollController.jumpTo(offset));
      // .jumpTo(offset - MediaQuery.of(context).size.height / 3));
      // .animateTo(offset,
      //     duration: const Duration(milliseconds: 100),
      //     curve: Curves.linear));
    });
  }

  double get offset => (DateTime.now().hour * 60.0 + DateTime.now().minute);

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    timer.cancel();
  }

  @override
  void didUpdateWidget(covariant WeeklyScheduledEvents oldWidget) {
    super.didUpdateWidget(oldWidget);
    scrollController.animateTo(offset,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child: CustomPaint(
          painter: widget.showTimeLine ? TimeLinePainter(offset: offset) : null,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Expanded(flex: 1, child: HourLabels()),
            for (int day = 0; day < 7; day++)
              Expanded(
                flex: 2,
                child: DayCol(date: widget.date.add(Duration(days: day))),
              ),
          ]),
        ),
      ),
    );
  }
}
