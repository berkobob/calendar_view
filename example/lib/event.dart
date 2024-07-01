import 'package:calendar_view/calendar_view.dart';

class CalendarEvent implements CVEvent {
  @override
  String source;
  @override
  String id;
  @override
  String summary;
  @override
  String? description;
  @override
  bool isAllDay;
  @override
  DateTime start;
  @override
  String? location;
  String? colorId;
  @override
  DateTime end;

  CalendarEvent({
    required this.source,
    required this.id,
    required this.summary,
    this.description,
    required this.isAllDay,
    required this.start,
    this.location,
    this.colorId,
    required this.end,
  });

  CalendarEvent.fromJson(Map<String, dynamic> json)
      : this(
          source: 'dummy calendar',
          id: json['id'],
          summary: json['summary'] ?? 'Private Event',
          description: json['description'],
          isAllDay: json['start']['date'] != null,
          start:
              DateTime.parse(json['start']['date'] ?? json['start']['dateTime'])
                  .toLocal(),
          location: json['location'],
          colorId: json['colorId']?.replaceFirst('#', 'ff'),
          end: DateTime.parse(json['end']['date'] ?? json['end']['dateTime'])
              .toLocal(),
        );

  @override
  int get color => int.parse(colorId ?? '0', radix: 16);

  @override
  String toString() => '$id\t$summary on $start till $end';

  @override
  int compareTo(other) => start.compareTo(other.start);

  @override
  int get hashCode => Object.hash(id, summary, start);

  @override
  bool operator ==(Object other) {
    if (other is! CVEvent) return false;
    return id == other.id;
  }
}
