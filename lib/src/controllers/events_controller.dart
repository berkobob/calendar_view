import 'dart:async';

import 'package:calendar_view/src/consts/same_date_ext.dart';

import '../models/models.dart';

class EventsController {
  final List<Event> _events;
  late final DateTime initDate;
  static final StreamController<Message> _eventMessages = StreamController();
  final StreamController<dynamic> _updateStream =
      StreamController<dynamic>.broadcast();

  static get msg => _eventMessages.add;

  Stream get updates => _updateStream.stream;

  EventsController(
      {List<Event> initEvents = const <Event>[], DateTime? initDate})
      : _events = initEvents {
    _eventMessages.stream.listen((Message msg) => switch (msg) {
          AddEvents() => addAll(msg.events),
          AddEvent() => addAll([msg.event]),
          RemoveEvents() => removeWhere(msg.where),
        });

    this.initDate =
        initDate ?? (_events.isNotEmpty ? _events.first.start : DateTime.now());
  }

  Iterable<Event> get allDayEvents => _events.where((event) => event.isAllDay);

  Iterable<Event> get scheduledEvents =>
      _events.where((event) => !event.isAllDay);

  void remove(Event event) => _events.remove(event);

  Event firstWhere(bool Function(Event event) function) =>
      _events.firstWhere(function);

  void removeWhere(bool Function(Event event) function) {
    _events.removeWhere(function);
    _updateStream.sink.add(true);
  }

  void addAll(List<Event> events) {
    _events.addAll(events);
    _events.sort();
    _updateStream.sink.add(null);
  }

  Iterable<Event> allDayEventsBetween(DateTime from, DateTime to) {
    return allDayEvents.where((event) {
      if (event.recurrenceRule == null) {
        if (event.start.isBefore(to) && event.end.isAfter(from)) {
          return true;
        } else {
          return false;
        }
      }

      for (var date in event.recurrenceRule!.previousDates) {
        if (date.$1.isBefore(to) && date.$2.isAfter(from)) {
          event.start = date.$1;
          event.end = date.$2;
          return true;
        }
      }
      return false;
    });
  }

  Iterable<Event> scheduledEventsOn(DateTime date) {
    return scheduledEvents.where((event) {
      if (event.recurrenceRule == null) {
        return (event.start.isSameDate(date) || event.end.isSameDate(date));
      }

      for (var occurrence in event.recurrenceRule!.previousDates) {
        if (occurrence.$1.isSameDate(date) || occurrence.$2.isSameDate(date)) {
          return true;
        }
      }
      return false;
    });
  }
}
