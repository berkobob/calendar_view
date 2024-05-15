import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../controllers/weekly_controller.dart';
import 'weekly_app_bar.dart';
import 'weekly_date_row.dart';
import 'weekly_scheduled_events/weekly_scheduled_events.dart';
import 'weely_all_day_events/weekly_all_day_event_drop_target.dart';
import 'weely_all_day_events/weekly_all_day_events.dart';

class WeeklyView extends StatelessWidget {
  const WeeklyView({super.key});

  @override
  Widget build(BuildContext context) {
    final wc = di.get<WeeklyController>();

    return Scaffold(
      appBar: wc.showAppBar ? const WeeklyAppBar() : null,
      body: PageView.builder(
          controller: wc.pageController,
          itemBuilder: (BuildContext context, int pageNumber) {
            return const Column(children: [
              Stack(
                children: [
                  Positioned.fill(
                    child: WeeklyAllDayEventDropTarget(),
                  ),
                  Column(
                    children: [
                      WeeklyDateRow(),
                      Divider(),
                      WeeklyAllDayEvents(),
                    ],
                  ),
                ],
              ),
              WeeklyScheduledEvents(),
            ]);
          }),
    );
  }
}
