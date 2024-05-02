import 'package:flutter/material.dart';

import 'consts/calendar_views.dart';
import 'controllers/controller.dart';
import 'models/event.dart';
import 'weekly/weekly_view.dart';

class CalendarView extends StatefulWidget {
  const CalendarView(
      {required this.events,
      required this.view,
      required this.initialDate,
      this.showAppBar = false,
      this.showTimeLine = true,
      super.key});

  final List<Event> events;
  final CalendarViews view;
  final DateTime initialDate;
  final bool showAppBar;
  final bool showTimeLine;

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late final Controller controller;

  @override
  void initState() {
    super.initState();
    controller =
        Controller(events: widget.events, initDate: widget.initialDate);
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.view) {
      CalendarViews.weekly => WeeklyView(
          controller: controller,
          showAppBar: widget.showAppBar,
          showTimeLine: widget.showTimeLine),
      // : Handle this case.
      CalendarViews.daily => throw UnimplementedError(),
      // : Handle this case.
      CalendarViews.monthly => throw UnimplementedError(),
      // : Handle this case.
      CalendarViews.yearly => throw UnimplementedError(),
      // : Handle this case.
      CalendarViews.agenda => throw UnimplementedError(),
      // : Handle this case.
      CalendarViews.schedule => throw UnimplementedError(),
    };
  }
}
