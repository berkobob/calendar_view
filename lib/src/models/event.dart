class CVEvent implements Comparable {
  final dynamic source;
  final String summary;
  final String? description;
  late bool isAllDay;
  late DateTime start;
  final String? location;
  late DateTime end;
  String? colorId;

  int get color => int.parse(colorId ?? 'ffffffff', radix: 16);

  CVEvent({
    required this.source,
    required this.summary,
    this.description,
    DateTime? start,
    DateTime? end,
    bool? isAllDay,
    this.location,
    this.colorId,
  }) {
    if (isAllDay != null) this.isAllDay = isAllDay;
    this.start = start ?? DateTime.now();
    this.end = end ?? this.start.add(const Duration(hours: 1));
  }

  @override
  int compareTo(other) => start.compareTo(other.start);

  @override
  int get hashCode => Object.hash(summary, start, end);

  @override
  bool operator ==(Object other) {
    if (other is! CVEvent) return false;
    return hashCode == other.hashCode;
  }

  @override
  String toString() => '$summary on $start till $end';
}
