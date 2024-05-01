import 'package:flutter/material.dart';

import '../controllers/controller.dart';
import 'widgets/weekly_allday_events.dart';
import 'widgets/weekly_calendar.dart';
import 'widgets/weekly_date_row.dart';

class WeeklyView extends StatelessWidget {
  const WeeklyView({required this.controller, super.key});
  final Controller controller;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (BuildContext context, int weekIndex) => Column(
        children: [
          WeeklyDateRow(cells: controller.getDates(weekIndex)),
          const Divider(),
          // WeeklyMultidayEvents(
          //     events: controller.getMultidayEvents(week: 10, year: 2024)),
          WeeklyAlldayEvents(
              events: controller.getAlldayEvents(week: 10, year: 2024)),
          // WeeklyCalendar(controller.getEvents(week: 10, year: 2024)),
          const WeeklyCalendar(),
        ],
      ),
    );
  }
}
