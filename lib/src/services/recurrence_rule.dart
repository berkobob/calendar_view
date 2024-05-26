class RecurrenceRule {
  final String frequency;
  final int interval;
  final DateTime? until;
  final int? count;
  final List<int> byMonth;
  final List<int> byMonthDay;
  final List<int> byDay;
  List<DateTime> previousStarts = [];
  List<DateTime> previousEnds = [];
  final List<(int, int)> previousWeekStarts = [];
  final List<(int, int)> previousWeekEnds = [];
  final List<(DateTime, DateTime)> previousDates = [];

  RecurrenceRule({
    required this.frequency,
    required this.interval,
    this.until,
    this.count,
    required this.byMonth,
    required this.byMonthDay,
    required this.byDay,
  });

  factory RecurrenceRule.fromString(String rrule) {
    // final String rrule =
    //     rrules.firstWhere((s) => s.contains('RRULE:')).replaceAll('RRULE:', '');

    Map<String, String> parts = {};
    for (var part in rrule.split(';')) {
      var keyValue = part.split('=');
      parts[keyValue[0]] = keyValue[1];
    }

    return RecurrenceRule(
      frequency: parts['FREQ']!,
      interval:
          parts.containsKey('INTERVAL') ? int.parse(parts['INTERVAL']!) : 1,
      until:
          parts.containsKey('UNTIL') ? DateTime.parse(parts['UNTIL']!) : null,
      count: parts.containsKey('COUNT') ? int.parse(parts['COUNT']!) : null,
      byMonth: parts.containsKey('BYMONTH')
          ? parts['BYMONTH']!.split(',').map(int.parse).toList()
          : [],
      byMonthDay: parts.containsKey('BYMONTHDAY')
          ? parts['BYMONTHDAY']!.split(',').map(int.parse).toList()
          : [],
      byDay: parts.containsKey('BYDAY')
          ? parts['BYDAY']!.split(',').map((d) {
              try {
                return _dayOfWeekFromString(d);
              } catch (e) {
                throw ArgumentError('Invalid day: $d\nRule $rrule');
              }
            }).toList()
          : [],
    );
  }

  static int _dayOfWeekFromString(String dayString) {
    final day = dayString.length == 3 ? dayString.substring(1) : dayString;
    switch (day) {
      case 'MO':
        return DateTime.monday;
      case 'TU':
        return DateTime.tuesday;
      case 'WE':
        return DateTime.wednesday;
      case 'TH':
        return DateTime.thursday;
      case 'FR':
        return DateTime.friday;
      case 'SA':
        return DateTime.saturday;
      case 'SU':
        return DateTime.sunday;
      default:
        throw ArgumentError('Invalid day: $day');
    }
  }

  void occurences({required DateTime start, required DateTime end}) {
    if (previousDates.isEmpty) {
      final duration = end.difference(start);
      final occ = _generateOccurrences(start);
      for (var o in occ) {
        previousDates.add((o, o.add(duration)));
      }
    }
  }

  List<DateTime> _generateOccurrences(DateTime startDate) {
    List<DateTime> occurrences = [];
    DateTime current = startDate;
    int occurrenceCount = 0;

    while ((count == null || occurrenceCount < (count ?? 0)) &&
        (until == null || current.isBefore(until!)) &&
        current.isBefore(DateTime.now())) {
      if (frequency == 'DAILY') {
        current = current.add(Duration(days: interval));
      } else if (frequency == 'WEEKLY') {
        current = current.add(Duration(days: 7 * interval));
      } else if (frequency == 'MONTHLY') {
        current = DateTime(current.year, current.month + interval, current.day);
      } else if (frequency == 'YEARLY') {
        current = DateTime(current.year + interval, current.month, current.day);
      }

      if ((byMonth.isEmpty || byMonth.contains(current.month)) &&
          (byMonthDay.isEmpty || _isDayOfMonth(current, byMonthDay)) &&
          (byDay.isEmpty || byDay.contains(current.weekday))) {
        occurrences.add(current);
        occurrenceCount++;
      }
    }
    return occurrences;
  }

  bool _isDayOfMonth(DateTime date, List<int> days) {
    if (days.contains(date.day)) {
      return true;
    }
    if (days.contains(-1) &&
        date.day == DateTime(date.year, date.month + 1, 0).day) {
      return true;
    }
    return false;
  }
}

// void main() {
//   String rruleString = "FREQ=YEARLY;INTERVAL=1;BYMONTH=1;BYMONTHDAY=1";

//   RecurrenceRule rule = RecurrenceRule.fromString(['RRULE:$rruleString']);

//   DateTime startDate = DateTime(2025, 1, 1); // Start date in the future
//   List<DateTime> occurrences = rule._generateOccurrences(startDate);

//   for (var date in occurrences) {
//     print(date);
//   }
// }
