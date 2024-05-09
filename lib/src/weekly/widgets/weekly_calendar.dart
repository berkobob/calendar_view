import 'dart:async';

import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../controllers/weekly_controller.dart';
import '../../models/event.dart';
import 'day_col.dart';
import 'hour_labels.dart';
import 'time_line_painter.dart';

class WeeklyCalendar extends StatefulWidget {
  const WeeklyCalendar(this.date, {super.key});
  final DateTime date;

  @override
  State<WeeklyCalendar> createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  late final ScrollController scrollController;
  late final Timer timer;
  double offset = 0.0;
  final showTimeLine = di.get<WeeklyController>().showTimeLine;
  late final List<List<Event>> events;

  @override
  void initState() {
    super.initState();
    offset = (DateTime.now().hour * 60 + DateTime.now().minute).toDouble();
    scrollController =
        ScrollController(initialScrollOffset: offset, keepScrollOffset: true);

    timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() => offset =
          (DateTime.now().hour * 60 + DateTime.now().minute).toDouble());
    });
    events = di.get<WeeklyController>().getEvents(widget.date);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    timer.cancel();
  }

  @override
  void didUpdateWidget(covariant WeeklyCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    offset = (DateTime.now().hour * 60 + DateTime.now().minute).toDouble();
    scrollController.animateTo(offset,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child: CustomPaint(
          painter: showTimeLine ? TimeLinePainter(offset: offset) : null,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Expanded(flex: 1, child: HourLabels()),
            for (int day = 0; day < 7; day++)
              Expanded(
                flex: 2,
                child: DayCol(
                    date: widget.date.add(Duration(days: day)),
                    events: events[day]),
              ),
          ]),
        ),
      ),
    );
  }
}
