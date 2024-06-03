import '../consts/event_status.dart';
import '../consts/event_type.dart';
import 'item.dart';

class Event extends Item implements Comparable {
  final String? id;
  final String? description;
  bool isAllDay;
  DateTime start;
  final String? location;
  String? colorId = '';
  DateTime end;
  final String calendar;
  bool recurring;
  EventStatus status;
  EventType? eventType;

  Event({
    this.id,
    required super.summary,
    this.description,
    required this.isAllDay,
    required this.start,
    this.location,
    this.colorId,
    required this.end,
    required this.calendar,
    required this.recurring,
    required this.status,
    required this.eventType,
  });

  int get color => int.parse(colorId!.replaceFirst('#', 'ff'), radix: 16);

  Event.fromJson(Map<String, dynamic> json, {required this.calendar})
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
        recurring = json.containsKey('recurrence'),
        eventType = switch (json['eventType'] as String?) {
          'default' => EventType.event,
          'outOfOffice' => EventType.outOfOffice,
          'focusTime' => EventType.focusTime,
          'workingLocation' => EventType.workingLocation,
          'fromGmail' => EventType.fromGmail,
          null => null,
          Object() => null
        },
        status = switch (json['status'] as String) {
          'confirmed' => EventStatus.confirmed,
          'tentative' => EventStatus.tentative,
          'cancelled' => EventStatus.cancelled,
          String() => throw 'Unknown event status: $json'
        },
        super(summary: json['summary'] ?? 'Private Event');

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
        'recurring': recurring,
        'status': status,
        'eventType': eventType,
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
        recurring = json['recurring'] ?? false,
        status = json['status'] ?? EventStatus.confirmed,
        eventType = json['eventType'] ?? EventType.event,
        super(summary: json['summary']);

  @override
  String toString() =>
      '$summary on $start till $end and ${isAllDay ? "is all day" : "is not all day"}';

  @override
  int compareTo(other) => start.compareTo(other.start);
}
