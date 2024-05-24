import '../services/recurrence_rule.dart';
import 'task.dart';

class Event extends Task implements Comparable {
  final String? id;
  final String? description;
  bool isAllDay;
  DateTime start;
  final String? location;
  String? colorId;
  DateTime end;
  final String? calendar;
  final RecurrenceRule? recurrenceRule;

  Event(
      {this.id,
      required super.summary,
      this.description,
      required this.isAllDay,
      required this.start,
      this.location,
      this.colorId,
      required this.end,
      this.calendar,
      this.recurrenceRule});

  Event.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        description = json['description'],
        isAllDay = json['start']['date'] != null,
        start =
            DateTime.parse(json['start']['date'] ?? json['start']['dateTime'])
                .toLocal(),
        location = json['location'],
        colorId = json['colorId'],
        end = DateTime.parse(json['end']['date'] ?? json['end']['dateTime'])
            .toLocal(),
        calendar = json['calendar'],
        recurrenceRule = json.containsKey('recurrence')
            ? RecurrenceRule.fromString(json['recurrence'] as List)
            : null,
        super(summary: json['summary'] ?? 'Private Event') {
    recurrenceRule?.occurences(start: start, end: end);
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
        'calendar': calendar,
        'recurrence': recurrenceRule
      };

  Event.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        description = json['description'],
        isAllDay = json['isAllDay'],
        start = json['start'],
        location = json['location'],
        colorId = json['colorId'],
        end = json['end'],
        calendar = json['calendar'],
        recurrenceRule = json['recurrence'],
        super(summary: json['summary']);

  @override
  String toString() =>
      '$summary on $start till $end and ${isAllDay ? "is all day" : "is not all day"}';

  @override
  int compareTo(other) => start.compareTo(other.start);
}
