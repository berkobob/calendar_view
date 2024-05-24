import 'event.dart';

class ScheduledEvent implements Comparable {
  ScheduledEvent(this.event);

  final Event event;

  DateTime get start => event.start;
  DateTime get end => event.end;
  String get summary => event.summary;

  String get startTimeString =>
      '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';

  String get endTimeString =>
      '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';

  double get duration => start.difference(end).inMinutes.abs().toDouble();

  double get startTimeInMinutes => start.hour * 60.0 + start.minute;

  @override
  String toString() => '$summary on $start till $end';

  @override
  int compareTo(other) => start.compareTo(other.start);
}
