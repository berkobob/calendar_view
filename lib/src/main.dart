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
      super.key});

  final List<Event> events;
  final CalendarViews view;
  final DateTime initialDate;

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
      CalendarViews.weekly => WeeklyView(controller: controller),
      // TODO: Handle this case.
      CalendarViews.daily => throw UnimplementedError(),
      // TODO: Handle this case.
      CalendarViews.monthly => throw UnimplementedError(),
      // TODO: Handle this case.
      CalendarViews.yearly => throw UnimplementedError(),
      // TODO: Handle this case.
      CalendarViews.agenda => throw UnimplementedError(),
      // TODO: Handle this case.
      CalendarViews.schedule => throw UnimplementedError(),
    };
  }
}
