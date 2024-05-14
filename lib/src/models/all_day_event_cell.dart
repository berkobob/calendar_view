class AllDayEventCell implements Comparable {
  DateTime date;
  int duration;
  String summary;
  String? calendar;
  int? overflow;
  int? underflow;

  AllDayEventCell({
    required this.summary,
    date,
    this.duration = 1,
    this.calendar,
  }) : date = date ?? DateTime.fromMicrosecondsSinceEpoch(0);

  @override
  String toString() =>
      'Date: $date\tDays: $duration\tSummary: $summary\tOverflow $overflow\tUnderflow $underflow';

  @override
  int compareTo(other) => date.compareTo(other.date);
}
