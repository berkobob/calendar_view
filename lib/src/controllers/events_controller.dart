import 'dart:async';

import '../models/event.dart';

class EventsController {
  final List<CVEvent> _events;
  late final DateTime initDate;
  static final StreamController<List<CVEvent>> events = StreamController();
  final StreamController<dynamic> _updateStream =
      StreamController<dynamic>.broadcast();

  Stream get updates => _updateStream.stream;

  EventsController(
      {List<CVEvent> initEvents = const <CVEvent>[], DateTime? initDate})
      : _events = initEvents {
    events.stream.listen((e) {
      _events.addAll(e);
      _events.sort();
      _updateStream.sink.add(e);
    });

    this.initDate =
        initDate ?? (_events.isNotEmpty ? _events.first.start : DateTime.now());
  }

  Iterable<CVEvent> get allDayEvents =>
      _events.where((event) => event.isAllDay);

  Iterable<CVEvent> get scheduledEvents =>
      _events.where((event) => !event.isAllDay);

  void remove(CVEvent event) => _events.remove(event);

  CVEvent firstWhere(bool Function(CVEvent event) function) =>
      _events.firstWhere(function);
}
