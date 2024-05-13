import 'package:week_of_year/date_week_extensions.dart';

class Event implements Comparable {
  final String id;
  final String summary;
  final String? description;
  final bool isAllDay;
  DateTime start;
  final String? location;
  String? colorId;
  DateTime end;
  final String calendar;

  int get week => start.weekOfYear;
  int get year => start.year;

  String get startTimeString =>
      '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
  String get endTimeString =>
      '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
  double get duration => start.difference(end).inMinutes.abs().toDouble();
  double get top => start.hour * 60.0 + start.minute;
  int get durationInDays => end.difference(start).inDays.abs();

  Event(
      {required this.id,
      required this.summary,
      this.description,
      required this.isAllDay,
      required this.start,
      this.location,
      this.colorId,
      required this.end,
      required this.calendar});

  Event.fromJson(Map<String, dynamic> json, {required this.calendar})
      : id = json['id'],
        summary = json['summary'] ?? 'Private Event',
        description = json['description'],
        isAllDay = json['start']['date'] != null,
        start =
            DateTime.parse(json['start']['date'] ?? json['start']['dateTime']),
        location = json['location'],
        colorId = json['colorId'],
        end = DateTime.parse(json['end']['date'] ?? json['end']['dateTime']) {
    if (json['recurrence'] case var rules? when rules is List) {
      final frequency = rules
          .firstWhere((x) => x.contains('RRULE'))
          .split(':')[1]
          .split(';')
          .firstWhere((String x) => x.contains('FREQ'))
          .split('=')[1];

      if (frequency == 'YEARLY') {
        start = DateTime(DateTime.now().year, start.month, start.day);
        if (isAllDay) end = start.add(const Duration(days: 1));
      }
    }
  }

  @override
  String toString() =>
      '$year:$week - $summary on $start till $end and ${isAllDay ? "is all day" : "is not all day"}';

  @override
  int compareTo(other) => start.compareTo(other.start);
}
