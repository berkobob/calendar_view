import 'task.dart';

class CVEvent extends CVTask implements Comparable {
  final String? id;
  final String? description;
  bool isAllDay;
  DateTime start;
  final String? location;
  String? colorId;
  DateTime end;
  final String? calendar;

  CVEvent(
      {this.id,
      required super.summary,
      this.description,
      required this.isAllDay,
      required this.start,
      this.location,
      this.colorId,
      required this.end,
      this.calendar});

  CVEvent.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        description = json['description'],
        isAllDay = json['start']['date'] != null,
        start =
            DateTime.parse(json['start']['date'] ?? json['start']['dateTime']),
        location = json['location'],
        colorId = json['colorId'],
        end = DateTime.parse(json['end']['date'] ?? json['end']['dateTime']),
        calendar = json['calendar'],
        super(summary: json['summary'] ?? 'Private Event') {
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

  Map<String, dynamic> get toMap => {
        'id': id,
        'summary': summary,
        'description': description,
        'isAllDay': isAllDay,
        'start': start,
        'location': location,
        'colorId': colorId,
        'end': end,
        'calendar': calendar
      };

  CVEvent.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        description = json['description'],
        isAllDay = json['isAllDay'],
        start = json['start'],
        location = json['location'],
        colorId = json['colorId'],
        end = json['end'],
        calendar = json['calendar'],
        super(summary: json['summary']);

  @override
  String toString() =>
      '$summary on $start till $end and ${isAllDay ? "is all day" : "is not all day"}';

  @override
  int compareTo(other) => start.compareTo(other.start);
}
