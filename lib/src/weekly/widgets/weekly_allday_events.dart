import 'package:flutter/material.dart';

import '../../models/cell.dart';

class WeeklyAlldayEvents extends StatelessWidget {
  const WeeklyAlldayEvents({required this.events, super.key});
  final List<List<AllDayCell>> events;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: events
            .map((e) => Row(children: [
                  const Expanded(flex: 1, child: Text('Spare')),
                  ...e.map((e) => e.duration == 0
                      ? const Spacer(flex: 2)
                      : Expanded(
                          flex: 2 * e.duration,
                          child: WeeklyAllDayCell(e.summary)))
                ]))
            .toList());
  }
}

class WeeklyAllDayCell extends StatelessWidget {
  const WeeklyAllDayCell(this.summary, {super.key});
  final String summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(),
          color: Colors.amber[200]),
      child: Text(summary, softWrap: false, overflow: TextOverflow.fade),
    );
  }
}
