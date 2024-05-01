class Cell {}

class EventCell extends Cell {
  double topPadding = 0.0;
  double endPadding = 0.0;
  String? times;
  String? summary;

  @override
  String toString() => '$times\t$topPadding\t$endPadding\t$summary';
}

class DateCell extends Cell {
  DateTime dateTime;
  String day;
  String date;
  DateCell({required this.day, required this.date, required this.dateTime});

  @override
  String toString() => '$date\t$day';
}

class AlldayCell extends Cell {
  DateTime date;
  String summary;
  String? calendar;
  AlldayCell({required this.date, required this.summary});
}

class MultidayCell extends Cell {
  DateTime date;
  int days;
  String summary;
  String? calendar;

  MultidayCell({required this.date, required this.days, required this.summary});
}
