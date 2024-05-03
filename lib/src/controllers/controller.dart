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

  List<List<AllDayCell>> getAlldayEvents({required int pageNumber}) {
    final allDay = [
      AllDayCell(date: DateTime(2024, 3, 4), summary: 'Monday'),
      AllDayCell(date: DateTime(2024, 3, 4), duration: 2, summary: 'Multiday'),
      AllDayCell(date: DateTime(2024, 3, 5), duration: 4, summary: 'Multiday'),
      AllDayCell(date: DateTime(2024, 3, 5), summary: 'Tuesday'),
      AllDayCell(
          date: DateTime(2024, 3, 6),
          summary: 'Wednesday is the middle day of the week'),
      AllDayCell(date: DateTime(2024, 3, 7), summary: 'Thursday'),
      AllDayCell(date: DateTime(2024, 3, 7), summary: 'Thursday'),
      AllDayCell(date: DateTime(2024, 3, 7), summary: 'Thursday'),
      AllDayCell(date: DateTime(2024, 3, 8), summary: 'Friday'),
      AllDayCell(
          date: DateTime(2024, 3, 10),
          summary: 'Sunday is ht elast day of the week',
          duration: 7),
    ];

    final List<List<AllDayCell>> allDayCells = [];
    List<AllDayCell> row = [];
    int day = 1;
    while (allDay.isNotEmpty) {
      AllDayCell event = allDay.firstWhere(
        (element) => element.date.weekday == day,
        orElse: () =>
            AllDayCell(date: DateTime.now(), summary: '', duration: 0),
      );
      day = event.duration == 0 ? day + 1 : event.date.weekday + event.duration;
      if (day > 8) {
        event.overflow = event.duration - (8 - event.date.weekday);
        event.duration = 8 - event.date.weekday;
      }

      row.add(event);
      allDay.remove(event);
      if (day > 7) {
        allDayCells.add(row);
        row = [];
        day = 1;
      }
    }
    return allDayCells;
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
