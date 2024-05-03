class DateCell {
  DateTime dateTime;
  String day;
  String date;
  DateCell({required this.day, required this.date, required this.dateTime});

  @override
  String toString() => '$date\t$day';
}

class AlldayCell {
  DateTime date;
  int duration;
  String summary;
  String? calendar;
  AlldayCell(
      {required this.date,
      required this.summary,
      this.duration = 1,
      this.calendar});
  @override
  String toString() => 'Date: $date\tDays: $duration\tSummary: $summary';
}
