import 'package:calendar_view/src/weekly/all_day_event_drop_target.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../controllers/weekly_controller.dart';
import 'weekly_app_bar.dart';
import 'widgets/weekly_widgets.dart';

class WeeklyView extends StatelessWidget {
  const WeeklyView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = di.get<WeeklyController>();

    return PageView.builder(
      controller: controller.pageController,
      itemBuilder: (BuildContext context, int pageNumber) {
        final date = controller.dateFromPageNumber(pageNumber);

        return Scaffold(
          appBar: controller.showAppBar ? WeeklyAppBar(date: date) : null,
          body: Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      WeeklyDateRow(page: pageNumber),
                      const Divider(),
                      WeeklyAllDayEvents(page: pageNumber),
                    ],
                  ),
                  Positioned.fill(
                    child: AllDayEventDropTarget(date: date),
                  )
                ],
              ),
              WeeklyScheduledEvents(date,
                  showTimeLine: controller.showTimeLine),
            ],
          ),
        );
      },
    );
  }
}
