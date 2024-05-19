import '../models/event.dart';

class EventsController {
  final List<CVEvent> events;
  late final DateTime initDate;

  EventsController({List<CVEvent>? events, DateTime? initDate})
      : events = events ?? <CVEvent>[] {
    this.events.sort();
    this.initDate = initDate ??
        (this.events.isNotEmpty ? this.events.first.start : DateTime.now());
  }

  Iterable<CVEvent> get allDayEvents => events.where((event) => event.isAllDay);

  Iterable<CVEvent> get scheduledEvents =>
      events.where((event) => !event.isAllDay);

  // void addEvent(
  //     {required String task, required DateTime start, required DateTime end}) {
  //   print('Adding $task from $start to $end');
  // }
}
