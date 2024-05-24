import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import 'consts/calendar_view.dart';
import 'controllers/events_controller.dart';
import 'controllers/weekly_controller.dart';
import 'models/event.dart';
import 'weekly/weekly_view.dart';

/// The CVCalendar class is the root widget that represents a calendar view.
///
/// The constructor CVCalendar takes several optional parameters: view (defaults to CalendarView.weekly), initEvents (a list of Event objects), initDate (a DateTime object), showAppBar (a boolean, defaults to false), showTimeLine (a boolean, defaults to true), and autoScroll (a boolean, defaults to true). The constructor registers instances of EventsController and WeeklyController in the dependency injection system if they haven't been registered already.
/// The build method returns a widget based on the view parameter. If view is CalendarView.weekly, it returns a WeeklyView widget. Otherwise, it throws an UnimplementedError.
/// In summary, CVCalendar is a widget that displays a calendar view based on the specified view parameter. It handles the registration of EventsController and WeeklyController in the dependency injection system and provides a build method to return the appropriate widget based on the view parameter.

class CVCalendar extends StatelessWidget {
  CVCalendar({
    this.view = CalendarView.weekly,
    List<Event>? initEvents,
    DateTime? initDate,
    bool showAppBar = false,
    bool showTimeLine = true,
    bool autoScroll = true,
    super.key,
  }) {
    if (!di.isRegistered<EventsController>()) {
      di.registerSingleton<EventsController>(EventsController(
          initEvents: initEvents ?? <Event>[], initDate: initDate));
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
