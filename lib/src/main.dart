import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import 'consts/calendar_view.dart';
import 'controllers/events_controller.dart';
import 'controllers/weekly_controller.dart';
import 'models/event.dart';
import 'weekly/weekly_view.dart';

class CVCalendar extends StatelessWidget {
  CVCalendar({
    this.view = CalendarView.weekly,
    List<CVEvent>? initEvents,
    DateTime? initDate,
    bool showAppBar = false,
    bool showTimeLine = true,
    bool autoScroll = true,
    super.key,
  }) {
    // di.registerSingleton<StreamController<bool>>(
    //     StreamController<bool>.broadcast());
    if (!di.isRegistered<EventsController>()) {
      di.registerSingleton<EventsController>(EventsController(
          initEvents: initEvents ?? <CVEvent>[], initDate: initDate));
    }
    if (!di.isRegistered<WeeklyController>()) {
      di.registerLazySingleton(() => WeeklyController(
          showAppBar: showAppBar,
          showTimeLine: showTimeLine,
          autoScroll: autoScroll));
    }
  }

  final CalendarView view;

  @override
  Widget build(BuildContext context) {
    return switch (view) {
      CalendarView.weekly => const WeeklyView(),
      // : Handle this case.
      CalendarView.daily => throw UnimplementedError(),
      // : Handle this case.
      CalendarView.monthly => throw UnimplementedError(),
      // : Handle this case.
      CalendarView.yearly => throw UnimplementedError(),
      // : Handle this case.
      CalendarView.agenda => throw UnimplementedError(),
      // : Handle this case.
      CalendarView.schedule => throw UnimplementedError(),
      // : Handle this case.
      CalendarView.fiveDays => throw UnimplementedError(),
    };
  }
}
