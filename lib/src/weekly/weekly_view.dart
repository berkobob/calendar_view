import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../controllers/weekly_controller.dart';
import 'weekly_view_widgets/weekly_view_widgets.dart';

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
