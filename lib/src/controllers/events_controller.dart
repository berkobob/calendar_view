import '../models/event.dart';

class EventsController {
  final List<Event> events;
  late final DateTime initDate;

  EventsController({events, initDate}) : events = events ?? <Event>[] {
    events.sort();
    this.initDate = initDate ?? this.events.first ?? DateTime.now();
  }

  Iterable<Event> get allDayEvents => events.where((event) => event.isAllDay);

  Iterable<Event> get scheduledEvents =>
      events.where((event) => !event.isAllDay);

  // void addEvent(
  //     {required String task, required DateTime start, required DateTime end}) {
  //   print('Adding $task from $start to $end');
  // }
}
