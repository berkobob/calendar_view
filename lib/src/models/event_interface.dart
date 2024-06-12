abstract interface class CVEvent implements Comparable {
  dynamic get source;
  String get id;
  String get summary;
  String? get description;
  bool get isAllDay;
  DateTime get start;
  String? get location;
  DateTime get end;
  int get color;

  set start(DateTime start);
  set end(DateTime end);
  set isAllDay(bool isAllDay);

  @override
  int compareTo(other);

  @override
  int get hashCode;

  @override
  bool operator ==(Object other);
}
