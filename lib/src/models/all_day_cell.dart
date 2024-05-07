class AllDayCell implements Comparable {
  DateTime date;
  int duration;
  String summary;
  String? calendar;
  int? overflow;

  AllDayCell({
    required this.summary,
    date,
    this.duration = 1,
    this.calendar,
  }) : date = date ?? DateTime.fromMicrosecondsSinceEpoch(0);

  @override
  String toString() => 'Date: $date\tDays: $duration\tSummary: $summary';

  @override
  int compareTo(other) => date.compareTo(other.date);
}
