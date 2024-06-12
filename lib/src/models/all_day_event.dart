import 'event_interface.dart';

class AllDayEvent implements Comparable {
  AllDayEvent([this.event])
      : duration =
            event != null ? event.end.difference(event.start).inDays.abs() : 0;

  final CVEvent? event;
  int overflow = 0, underflow = 0, duration;

  set start(start) => event!.start = start;
  DateTime get start => event!.start;
  DateTime get end => event!.end;
  String get summary => event!.summary;

  @override
  String toString() =>
      'Date: $start\tDays: $duration\tSummary: $summary\tOverflow $overflow\tUnderflow $underflow';

  @override
  int compareTo(other) => start.compareTo(other.start);
}
