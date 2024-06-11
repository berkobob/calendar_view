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
  String? snackbarMessage;

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

  DateTime _monday = dateTimeFromWeekNumber(
      di.get<EventsController>().initDate.year,
      di.get<EventsController>().initDate.weekOfYear);
  DateTime get monday => _monday;
  set monday(DateTime date) {
    _monday = date;
    notifyListeners();
  }

  late final PageController pageController;

  WeeklyController(
      {required this.showAppBar,
      required this.showTimeLine,
      required this.autoScroll}) {
    pageController =
        PageController(initialPage: pageNumberFromDate(DateTime.now()));
    pageController.addListener(() {
      switch (pageController.page) {
        case (double page) when (page % 1.0 == 0.0):
          monday = dateFromPageNumber(page.toInt());
          _loadEventsForWeek();
      }
    });
    _loadEventsForWeek();

    eventsController.updates.listen((_) => _loadEventsForWeek());
  }
  // #TODO: Make these switches and notifiers
  // #TODO: Make autoscrolling an option

  DateTime dateFromPageNumber(int pageNumber) => dateTimeFromWeekNumber(
      eventsController.initDate.year,
      eventsController.initDate.weekOfYear + pageNumber);

  int pageNumberFromDate(DateTime date) =>
      (eventsController.initDate.difference(date).inDays / 7).floor().abs();

  void _getAllDayEvents() {
    final sunday = monday.add(const Duration(days: 7));
    final allDayEventsThisWeek = eventsController
        .allDayEventsBetween(monday, sunday)
        .map((e) => AllDayEvent(e))
        .toList();

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
        (day) => eventsController
            .scheduledEventsOn(monday.add(Duration(days: day)))
            //         .where((event) =>
            //             event.start.isSameDate(monday.add(Duration(days: day))))
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

  void addEvent(Event event) {
    event.id != null
        ? snackbarMessage = '${event.summary} moved to ${event.start}'
        : snackbarMessage = '${event.summary} added to ${event.calendar}';

    print(eventsController.remove(event));
    EventsController.pubEventChanges(event);
    event.isAllDay ? _getAllDayEvents() : _getScheduledEvents();
  }

  void setDuration(Event event, {required double duration}) {
    final mins = (duration / 15).round() * 15;
    event.end = event.start.add(Duration(minutes: mins));
    eventsController.remove(event);
    EventsController.pubEventChanges(event);
    snackbarMessage =
        '${event.summary} set to ${duration.toInt()} minutes ending at ${event.end}';
  }
}
