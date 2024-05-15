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

  List<List<ScheduledEvent>> scheduledEvents =
      List.generate(7, (_) => <ScheduledEvent>[]);

  AllDayEvents allDayEvents = List.generate(7, (_) => <AllDayEvent>[]);

  ValueNotifier<CrossFadeState> showAllDayEvents =
      ValueNotifier(CrossFadeState.showFirst);

  void setShowAllDayEvents(bool value) {
    showAllDayEvents.value =
        value ? CrossFadeState.showFirst : CrossFadeState.showSecond;
  }

  ValueNotifier<DateTime> monday =
      ValueNotifier(di.get<EventsController>().initDate);

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

  void _getAllDayEvents(int pageNumber) {
    final monday = dateFromPageNumber(pageNumber);
    final allDayEventsThisWeek = eventsController.allDayEvents
        .where((event) =>
            event.start.isBefore(monday.add(const Duration(days: 7))) &&
            event.end.isAfter(monday))
        .map((event) => AllDayEvent(event))
        .toList()
      ..sort();

    List<AllDayEvent> row = [];
    int day = 1;
    allDayEvents = [];

    while (allDayEventsThisWeek.isNotEmpty) {
      AllDayEvent event = allDayEventsThisWeek.firstWhere(
        (event) =>
            event.start.weekday == day ||
            (event.start.weekOfYear < monday.weekOfYear),
        orElse: () => AllDayEvent(),
      );

      if (event.event != null &&
          event.start.weekOfYear < monday.weekOfYear &&
          event.summary != '') {
        event.underflow = monday.difference(event.start).inDays.abs();
        event.duration -= event.underflow;
        event.start = monday;
      }

      day =
          event.duration == 0 ? day + 1 : event.start.weekday + event.duration;
      if (day > 8) {
        event.overflow = event.duration - (8 - event.start.weekday);
        event.duration = 8 - event.start.weekday;
      }

      row.add(event);
      allDayEventsThisWeek.remove(event);
      if (day > 7) {
        allDayEvents.add(row);
        row = [];
        day = 1;
      }
    }
    if (row.isNotEmpty) {
      for (int i = day; i <= 7; i++) {
        row.add(AllDayEvent());
      }
      allDayEvents.add(row);
    }
  }

// #TODO Drag to extend task time
// #TODO Drag all day events to a scheduled time

  void _loadEventsForWeek(int page) {
    final week = dateFromPageNumber(page);
    scheduledEvents = List.generate(
        7,
        (day) => eventsController.scheduledEvents
            .where((event) =>
                event.start.isSameDate(week.add(Duration(days: day))))
            .map((event) => ScheduledEvent(event))
            .toList()
          ..sort());
    _getAllDayEvents(page);
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
    scheduledEvents[start.weekday - 1].add(ScheduledEvent(event));
    // events[start.weekday - 1].sort();
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
    _getAllDayEvents(pageController.page!.toInt());
    notifyListeners();
  }
}
