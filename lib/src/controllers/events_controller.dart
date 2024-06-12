import 'dart:async';

import '../consts/same_date_ext.dart';

import '../models/models.dart';

class EventsController {
  final List<CVEvent> _events;
  late final DateTime initDate;

  static final StreamController<Message> _eventMessages = StreamController();
  // Receive new [Event]s on this stream
  static get msg => _eventMessages.add;

  // When [_events] change notify other controllers
  Stream get updates => _updateStream.stream;

  // When exiting [_events] change, notify listeners
  static final StreamController<CVEvent> _pubEventChange = StreamController();
  static get eventChanges => _pubEventChange.stream;
  static get pubEventChanges => _pubEventChange.add;

  final StreamController<dynamic> _updateStream =
      StreamController<dynamic>.broadcast();

  EventsController(
      {List<CVEvent> initEvents = const <CVEvent>[], DateTime? initDate})
      : _events = initEvents {
    _eventMessages.stream.listen((Message msg) => switch (msg) {
          AddEvents() => addAll(msg.events.toList()),
          AddEvent() => addAll([msg.event]),
          RemoveEvents() => removeWhere(msg.where),
        });

    this.initDate =
        initDate ?? (_events.isNotEmpty ? _events.first.start : DateTime.now());
  }

  Iterable<CVEvent> get allDayEvents =>
      _events.where((event) => event.isAllDay);

  Iterable<CVEvent> get scheduledEvents =>
      _events.where((event) => !event.isAllDay);

  bool remove(CVEvent event) => _events.remove(event);

  CVEvent firstWhere(bool Function(CVEvent event) function) =>
      _events.firstWhere(function);

  void removeWhere(bool Function(CVEvent event) function) {
    _events.removeWhere(function);
    _updateStream.sink.add(true);
  }

  void addAll(final List<CVEvent> events) {
    _events.addAll(events);
    // _events.sort();
    _updateStream.sink.add(null);
  }

  Iterable<CVEvent> allDayEventsBetween(DateTime from, DateTime to) =>
      allDayEvents.where(
          (event) => event.start.isBefore(to) && event.end.isAfter(from));

  Iterable<CVEvent> scheduledEventsOn(DateTime date) => scheduledEvents.where(
      (event) => (event.start.isSameDate(date) || event.end.isSameDate(date)));
}
