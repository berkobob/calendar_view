import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import 'consts/calendar_views.dart';
import 'controllers/events_controller.dart';
import 'controllers/weekly_controller.dart';
import 'models/event.dart';
import 'weekly/weekly_view.dart';

class CalendarView extends StatelessWidget {
  CalendarView({
    this.view = CalendarViews.weekly,
    List<CVEvent>? events,
    DateTime? initDate,
    bool showAppBar = false,
    bool showTimeLine = true,
    bool autoScroll = true,
    super.key,
  }) {
    if (!di.isRegistered<EventsController>()) {
      di.registerSingleton<EventsController>(
          EventsController(events: events, initDate: initDate));
    }
    if (!di.isRegistered<WeeklyController>()) {
      di.registerLazySingleton(() => WeeklyController(
          showAppBar: showAppBar,
          showTimeLine: showTimeLine,
          autoScroll: autoScroll));
    }
  }

  final CalendarViews view;

  @override
  Widget build(BuildContext context) {
    return switch (view) {
      CalendarViews.weekly => const WeeklyView(),
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
      // : Handle this case.
      CalendarViews.fiveDays => throw UnimplementedError(),
    };
  }
}
