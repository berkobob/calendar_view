import 'package:week_of_year/date_week_extensions.dart';
import 'package:week_of_year/datetime_from_week_number.dart';

import '../models/cell.dart';
import '../consts/days_of_week.dart';
import '../models/event.dart';

class Controller {
  List<Event> events;
  DateTime initDate;
  Controller({required this.events, required this.initDate});

  DateTime dateFromPageNumber(int pageNumber) =>
      dateTimeFromWeekNumber(initDate.year, initDate.weekOfYear + pageNumber);

  int pageNumberFromDate(DateTime date) =>
      (initDate.difference(date).inDays / 7).floor().abs() - 1;

  List<DateCell> getDaysRow(int page) {
    final thisMonday = dateFromPageNumber(page);
    return List.generate(7, (days) {
      final item = thisMonday.add(Duration(days: days));
      return DateCell(
          date: '${item.day}',
          day: '${DaysOfWeek.values[item.weekday]}',
          dateTime: item);
    });
  }

  List<List<AlldayCell>> getAlldayEvents({required week, required year}) {
    return [
      [
        AlldayCell(date: DateTime(2024, 3, 4), summary: 'Monday'),
      ],
      [
        AlldayCell(date: DateTime(2024, 3, 5), summary: 'Tuesday'),
      ],
      [AlldayCell(date: DateTime(2024, 3, 6), summary: 'Wednesday')],
      [
        AlldayCell(date: DateTime(2024, 3, 7), summary: 'Thursday'),
        AlldayCell(date: DateTime(2024, 3, 7), summary: 'Thursday'),
        AlldayCell(date: DateTime(2024, 3, 7), summary: 'Thursday'),
      ],
      [AlldayCell(date: DateTime(2024, 3, 8), summary: 'Friday')],
      [],
      [AlldayCell(date: DateTime(2024, 3, 8), summary: 'Sunday')],
    ];
  }

  List<MultidayCell> getMultidayEvents({required week, required year}) {
    return [
      MultidayCell(date: DateTime(2024, 3, 4), days: 2, summary: 'Multiday')
    ];
  }

  List<List<Event>> getEvents(int pageNumber) {
    final today = dateFromPageNumber(pageNumber);
    return List.generate(
        7,
        (index) => events
            .where((event) =>
                _isSameDate(event.start, today.add(Duration(days: index))) &&
                !event.isAllDay)
            .toList()
          ..sort());
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
