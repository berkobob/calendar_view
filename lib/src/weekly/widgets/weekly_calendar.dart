import 'package:calendar_view/src/weekly/widgets/day.dart';
import 'package:calendar_view/src/weekly/widgets/hour.dart';
import 'package:flutter/material.dart';

class WeeklyCalendar extends StatelessWidget {
  const WeeklyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(flex: 1, child: Hour()),
            Expanded(flex: 2, child: Day()),
            Expanded(flex: 2, child: Day()),
            Expanded(flex: 2, child: Day()),
            Expanded(flex: 2, child: Day()),
            Expanded(flex: 2, child: Day()),
            Expanded(flex: 2, child: Day()),
            Expanded(flex: 2, child: Day()),
          ],
        ),
      ),
    );
  }
}
