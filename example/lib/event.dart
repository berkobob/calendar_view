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
  @override
  String? colorId;
  @override
  DateTime end;
  @override
  String calendar;

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
    required this.calendar,
  });

  // Event copyWith({
  //   String? source,
  //   String? id,
  //   String? summary,
  //   String? description,
  //   bool? isAllDay,
  //   DateTime? start,
  //   String? location,
  //   String? colorId,
  //   DateTime? end,
  //   String? calendar,
  //   bool? recurring,
  // }) {
  //   return CalendarEvent(
  //     source: source ?? this.source,
  //     id: id ?? this.id,
  //     summary: summary ?? this.summary,
  //     description: description ?? this.description,
  //     isAllDay: isAllDay ?? this.isAllDay,
  //     start: start ?? this.start,
  //     location: location ?? this.location,
  //     colorId: colorId ?? this.colorId,
  //     end: end ?? this.end,
  //     calendar: calendar ?? this.calendar,
  //   );
  // }

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
          calendar: 'test@testCalendar.com',
        );

  @override
  int? get color => int.tryParse(colorId ?? '0', radix: 16);

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
