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
  AllDayEvents allDayEvents = List.generate(7, (_) => <AllDayEventCell>[]);

  ValueNotifier<CrossFadeState> showAllDayEvents =
      ValueNotifier(CrossFadeState.showFirst);

  ValueNotifier<DateTime> monday =
      ValueNotifier(di.get<EventsController>().initDate);

  void setShowAllDayEvents(bool value) {
    showAllDayEvents.value =
        value ? CrossFadeState.showFirst : CrossFadeState.showSecond;
  }

  final PageController pageController = PageController();

  WeeklyController({required this.showAppBar, required this.showTimeLine}) {
    pageController.addListener(() {
      switch (pageController.page) {
        case (double page) when (page % 1.0 == 0.0):
          _loadEventsForWeek(page.toInt());
          monday.value = dateFromPageNumber(page.toInt());
      }
    });
    _loadEventsForWeek(0);
  }
  // #TODO: Make these switches and notifiers

  DateTime dateFromPageNumber(int pageNumber) => dateTimeFromWeekNumber(
      eventsController.initDate.year,
      eventsController.initDate.weekOfYear + pageNumber);

  int pageNumberFromDate(DateTime date) =>
      (eventsController.initDate.difference(date).inDays / 7).floor().abs() - 1;

  AllDayEvents _getAllDayEvents(int pageNumber) {
    final monday = dateFromPageNumber(pageNumber);
    final allDayEventsThisWeek = eventsController.allDayEvents
        .where((event) =>
            event.start.isBefore(monday.add(const Duration(days: 7))) &&
            event.end.isAfter(monday))
        .map(
          (e) => AllDayEventCell(
              date: e.start, summary: e.summary, duration: e.durationInDays),
        )
        .toList()
      ..sort();

    final AllDayEvents allDayEventCells = [];
    List<AllDayEventCell> row = [];
    int day = 1;

    while (allDayEventsThisWeek.isNotEmpty) {
      AllDayEventCell event = allDayEventsThisWeek.firstWhere(
        (event) =>
            event.date.weekday == day ||
            (event.date.weekOfYear < monday.weekOfYear),
        orElse: () => AllDayEventCell(summary: '', duration: 0),
      );

      if (event.date.weekOfYear < monday.weekOfYear && event.summary != '') {
        event.underflow = monday.difference(event.date).inDays.abs();
        event.duration -= event.underflow!;
        event.date = monday;
      }

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
    if (row.isNotEmpty) {
      for (int i = day; i <= 7; i++) {
        row.add(AllDayEventCell(summary: '', duration: 0));
      }
      allDayEventCells.add(row);
    }
    return allDayEventCells;
  }

// #TODO Drag to extend task time
// #TODO Drag all day events to a scheduled time

  void _loadEventsForWeek(int page) {
    final week = dateFromPageNumber(page);
    events = List.generate(
        7,
        (day) => eventsController.scheduledEvents
            .where((event) =>
                event.start.isSameDate(week.add(Duration(days: day))))
            .toList()
          ..sort());
    allDayEvents = _getAllDayEvents(page);
    notifyListeners();
  }

  void addScheduledEvent(
      {required String task, required DateTime start, required DateTime end}) {
    final event = Event(
        calendar: 'test',
        id: '2',
        summary: task,
        start: start,
        end: end,
        isAllDay: false);
    events[start.weekday - 1].add(event);
    notifyListeners();
  }

  void addAllDayEvent({required String task, required DateTime start}) {
    final event = Event(
        summary: task,
        start: start,
        end: start.add(const Duration(days: 1)),
        isAllDay: true,
        id: '',
        calendar: 'test');
    eventsController.events.add(event);
    allDayEvents = _getAllDayEvents(pageController.page!.toInt());
    notifyListeners();
  }
}
