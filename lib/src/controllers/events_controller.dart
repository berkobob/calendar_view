import '../models/event.dart';

class EventsController {
  List<Event> events;
  late DateTime initDate;

  EventsController({events, initDate}) : events = events ?? <Event>[] {
    events.sort();
    this.initDate = initDate ?? this.events.first ?? DateTime.now();
  }

  Iterable<Event> get allDayEvents => events.where((event) => event.isAllDay);
  Iterable<Event> get scheduledEvents =>
      events.where((event) => !event.isAllDay);
}
