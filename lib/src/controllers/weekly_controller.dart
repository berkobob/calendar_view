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
  final bool autoScroll;

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

  DateTime _monday = di.get<EventsController>().initDate;
  DateTime get monday => _monday;
  set monday(DateTime date) {
    _monday = date;
    notifyListeners();
  }

  final PageController pageController = PageController();

  WeeklyController(
      {required this.showAppBar,
      required this.showTimeLine,
      required this.autoScroll}) {
    pageController.addListener(() {
      switch (pageController.page) {
        case (double page) when (page % 1.0 == 0.0):
          monday = dateFromPageNumber(page.toInt());
          _loadEventsForWeek();
      }
    });
    _loadEventsForWeek();
  }
  // #TODO: Make these switches and notifiers
  // #TODO: Make autoscrolling an option

  DateTime dateFromPageNumber(int pageNumber) => dateTimeFromWeekNumber(
      eventsController.initDate.year,
      eventsController.initDate.weekOfYear + pageNumber);

  int pageNumberFromDate(DateTime date) =>
      (eventsController.initDate.difference(date).inDays / 7).floor().abs() - 1;

  void _getAllDayEvents() {
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

  // #TODO: look at checkboxes for tasks ☐

  void _getScheduledEvents() {
    scheduledEvents = List.generate(
        7,
        (day) => eventsController.scheduledEvents
            .where((event) =>
                event.start.isSameDate(monday.add(Duration(days: day))))
            .map((event) => ScheduledEvent(event))
            .toList()
          ..sort());
    notifyListeners();
  }

  void _loadEventsForWeek() {
    _getScheduledEvents();
    _getAllDayEvents();
    notifyListeners();
  }

  void addEvent({CVEvent? was, required CVEvent newEvent}) {
    if (was != null) {
      eventsController.events.remove(was);
      was.isAllDay
          ? _getAllDayEvents()
          : scheduledEvents[was.start.weekday - 1]
              .removeWhere((e) => e.event == was);
    }

    eventsController.events.add(newEvent);

    newEvent.isAllDay ? _getAllDayEvents() : _getScheduledEvents();

    notifyListeners();
  }

  void setDuration(CVEvent event, {required double duration}) {
    final mins = (duration / 15).round() * 15;
    final e = eventsController.events.firstWhere((e) => e == event);
    e.end = e.start.add(Duration(minutes: mins));
  }
}
