import 'package:calendar_view/src/consts/month_names.dart';
import 'package:flutter/material.dart';

class AppBarTitleCell extends StatelessWidget {
  const AppBarTitleCell(this.start, {super.key});
  final DateTime start;

  @override
  Widget build(BuildContext context) {
    final end = start.add(const Duration(days: 7));
    if (start.month == end.month) {
      return Text('${MonthNames.values[start.month]}, ${start.year}');
    }
    if (start.year == end.year) {
      return Text(
          '${MonthNames.values[start.month]} - ${MonthNames.values[end.month]}, ${start.year}');
    }
    return Text(
        '${MonthNames.values[start.month]}, ${start.year} - ${MonthNames.values[end.month]}, ${end.year}');
  }
}
