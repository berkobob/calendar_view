class DateCell {
  DateTime dateTime;
  String day;
  String date;
  DateCell({required this.day, required this.date, required this.dateTime});

  @override
  String toString() => '$date\t$day';
}
