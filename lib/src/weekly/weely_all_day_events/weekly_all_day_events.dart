import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../consts/typedefs.dart';
import '../../controllers/weekly_controller.dart';
import 'weekly_all_day_cell.dart';

class WeeklyAllDayEvents extends StatelessWidget with WatchItMixin {
  const WeeklyAllDayEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final wc = di.get<WeeklyController>();
    final events = watchPropertyValue<WeeklyController, AllDayEvents>(
        (wc) => wc.allDayEvents);

    final crossFadeState =
        watchValue<WeeklyController, CrossFadeState>((c) => c.showAllDayEvents);

    return AnimatedCrossFade(
      crossFadeState: crossFadeState,
      secondChild: ConstrainedBox(
        constraints: const BoxConstraints.tightForFinite(),
        child: Row(children: [
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () => wc.setShowAllDayEvents(true),
              icon: const Icon(Icons.expand_more),
              visualDensity: const VisualDensity(horizontal: -4.0),
            ),
          ),
          if (events.isNotEmpty)
            ...events[0].map((event) => event.duration == 0
                ? const Spacer(flex: 2)
                : Expanded(
                    flex: event.duration * 2,
                    child: WeeklyAllDayCell(event),
                  ))
        ]),
      ),
      firstChild: Column(
        children: events
            .map((event) => Row(children: [
                  events.indexOf(event) == 0
                      ? Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () => wc.setShowAllDayEvents(false),
                            icon: const Icon(Icons.expand_less),
                            visualDensity: const VisualDensity(vertical: -4.0),
                          ),
                        )
                      : const Spacer(),
                  ...event.map((event) => event.duration == 0
                      ? const Spacer(flex: 2)
                      : Expanded(
                          flex: 2 * event.duration,
                          child: WeeklyAllDayCell(event),
                        ))
                ]))
            .toList(),
      ),
      duration: const Duration(milliseconds: 250),
    );
  }
}
