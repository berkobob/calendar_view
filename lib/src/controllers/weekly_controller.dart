import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:week_of_year/date_week_extensions.dart';
import 'package:week_of_year/datetime_from_week_number.dart';

import '../models/models.dart';
import '../consts/constants.dart';
import 'events_controller.dart';

class WeeklyController with ChangeNotifier {
  final bool showAppBar;
  final bool showTimeLine;
  final eventsController = di.get<EventsController>();
  List<List<Event>> events = List.generate(7, (_) => <Event>[]);

  WeeklyController({required this.showAppBar, required this.showTimeLine});
  // #TODO: Make these switches and notifiers

  DateTime dateFromPageNumber(int pageNumber) => dateTimeFromWeekNumber(
      eventsController.initDate.year,
      eventsController.initDate.weekOfYear + pageNumber);

  int pageNumberFromDate(DateTime date) =>
      (eventsController.initDate.difference(date).inDays / 7).floor().abs() - 1;

  List<List<AllDayEventCell>> getAllDayEvents(int pageNumber) {
    final monday = dateFromPageNumber(pageNumber).weekOfYear;
    final allDayEventsThisWeek = eventsController.allDayEvents
        .where((event) => event.start.weekOfYear == monday)
        .map(
          (e) => AllDayEventCell(
              date: e.start, summary: e.summary, duration: e.durationInDays),
        )
        .toList()
      ..sort();

    final List<List<AllDayEventCell>> allDayEventCells = [];
    List<AllDayEventCell> row = [];
    int day = 1;
    while (allDayEventsThisWeek.isNotEmpty) {
      AllDayEventCell event = allDayEventsThisWeek.firstWhere(
        (element) =>
            DateTime(dateFromPageNumber(pageNumber).year, element.date.month,
                    element.date.day)
                .weekday ==
            day,
        orElse: () => AllDayEventCell(summary: '', duration: 0),
      );
      day = event.duration == 0 ? day + 1 : event.date.weekday + event.duration;
      if (day > 8) {
        event.overflow = event.duration - (8 - event.date.weekday);
        event.duration = 8 - event.date.weekday;
      }

      row.add(event);
      allDayEventsThisWeek.remove(event);
      if (day > 7) {
        allDayEventCells.add(row);
        row = [];
        day = 1;
      }
    }
    return allDayEventCells;
  }

  void loadEventsForWeek(DateTime week) {
    events = List.generate(
        7,
        (day) => eventsController.scheduledEvents
            .where((event) =>
                event.start.isSameDate(week.add(Duration(days: day))))
            .toList()
          ..sort());
  }

  void addEvent(
      {required String task, required DateTime start, required DateTime end}) {
    final event = Event(
        calendar: 'test',
        id: '2',
        summary: task,
        start: start,
        end: end,
        isAllDay: false);
    // eventsController.events.add(event);
    events[start.weekday - 1].add(event);
    notifyListeners();
  }
}
