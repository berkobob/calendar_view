import 'dart:async';

import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../controllers/weekly_controller.dart';
import 'day_col_widgets/day_col.dart';
import 'hour_labels.dart';
import 'time_line_painter.dart';

class WeeklyScheduledEvents extends StatefulWidget {
  const WeeklyScheduledEvents({super.key});

  @override
  State<WeeklyScheduledEvents> createState() => _WeeklyScheduledEventsState();
}

class _WeeklyScheduledEventsState extends State<WeeklyScheduledEvents> {
  final wc = di.get<WeeklyController>();
  final ScrollController scrollController = ScrollController();
  late final Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (wc.autoScroll) {
        setState(() => scrollController.jumpTo(time - 180.0));
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(time - 180.0);
    });
  }

  double get time => (DateTime.now().hour * 60.0 + DateTime.now().minute);

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child: CustomPaint(
          painter: wc.showTimeLine ? TimeLinePainter(offset: time) : null,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Expanded(flex: 1, child: HourLabels()),
            for (int day = 0; day < 7; day++)
              Expanded(flex: 2, child: DayCol(day: day)),
          ]),
        ),
      ),
    );
  }
}
