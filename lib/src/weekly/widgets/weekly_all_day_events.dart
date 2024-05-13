import 'package:calendar_view/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../controllers/weekly_controller.dart';

class WeeklyAllDayEvents extends StatelessWidget with WatchItMixin {
  const WeeklyAllDayEvents({required this.page, super.key});
  final int page;

  @override
  Widget build(BuildContext context) {
    final controller = di.get<WeeklyController>();
    final events =
        watchPropertyValue<WeeklyController, List<List<AllDayEventCell>>>(
            (c) => c.allDayEvents);

    final crossFadeState = watchPropertyValue<WeeklyController, CrossFadeState>(
        (c) => c.showAllDayEvents);
    return AnimatedCrossFade(
      crossFadeState: crossFadeState,
      secondChild: ConstrainedBox(
        constraints: const BoxConstraints.tightForFinite(),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () => controller.setShowAllDayEvents(true),
                  icon: const Icon(Icons.expand_more)),
            ),
            if (events.isNotEmpty)
              ...events[0].map((e) => e.duration == 0
                  ? const Spacer(flex: 2)
                  : Expanded(
                      flex: e.duration * 2, child: WeeklyAllDayCell(e.summary)))
          ],
        ),
      ),
      firstChild: Column(
          children: events
              .map((e) => Row(children: [
                    events.indexOf(e) == 0
                        ? Expanded(
                            flex: 1,
                            child: IconButton(
                                onPressed: () =>
                                    controller.setShowAllDayEvents(false),
                                icon: const Icon(Icons.expand_less)))
                        : const Spacer(),
                    ...e.map((e) => e.duration == 0
                        ? const Spacer(flex: 2)
                        : Expanded(
                            flex: 2 * e.duration,
                            child: WeeklyAllDayCell(e.summary,
                                overflow: e.overflow),
                          ))
                  ]))
              .toList()),
      duration: const Duration(milliseconds: 250),
    );
  }
}

class WeeklyAllDayCell extends StatelessWidget {
  const WeeklyAllDayCell(this.summary, {this.overflow, super.key});
  final String summary;
  final int? overflow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular((overflow ?? 0) < 0 ? 0 : 10.0),
            right: Radius.circular((overflow ?? 0) > 0 ? 0 : 10.0),
          ),
          border: Border(
            top: const BorderSide(),
            bottom: const BorderSide(),
            left: (overflow ?? 0) < 0 ? BorderSide.none : const BorderSide(),
            right: (overflow ?? 0) > 0 ? BorderSide.none : const BorderSide(),
          ),
          color: Colors.amber[200]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text((overflow ?? 0) < 0 ? '${overflow!.abs()} << ' : ''),
          Expanded(
              child: Text(summary,
                  softWrap: true, overflow: TextOverflow.fade, maxLines: 1)),
          Text((overflow ?? 0) > 0 ? '>> $overflow' : ''),
        ],
      ),
    );
  }
}
