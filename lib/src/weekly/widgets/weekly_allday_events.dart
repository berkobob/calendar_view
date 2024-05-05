import 'package:flutter/material.dart';

import '../../models/cell.dart';

class WeeklyAlldayEvents extends StatefulWidget {
  const WeeklyAlldayEvents({required this.events, super.key});
  final List<List<AllDayCell>> events;

  @override
  State<WeeklyAlldayEvents> createState() => _WeeklyAlldayEventsState();
}

class _WeeklyAlldayEventsState extends State<WeeklyAlldayEvents> {
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState: _crossFadeState,
      secondChild: ConstrainedBox(
        constraints: const BoxConstraints.tightForFinite(),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () => setState(
                      () => _crossFadeState = CrossFadeState.showFirst),
                  icon: const Icon(Icons.expand_more)),
            ),
            if (widget.events.isNotEmpty)
              ...widget.events[0].map((e) => e.duration == 0
                  ? const Expanded(flex: 2, child: DragTaskTarget())
                  : Expanded(
                      flex: e.duration * 2, child: WeeklyAllDayCell(e.summary)))
          ],
        ),
      ),
      firstChild: Column(
          children: widget.events
              .map((e) => Row(children: [
                    widget.events.indexOf(e) == 0
                        ? Expanded(
                            flex: 1,
                            child: IconButton(
                                onPressed: () => setState(() =>
                                    _crossFadeState =
                                        CrossFadeState.showSecond),
                                icon: const Icon(Icons.expand_less)))
                        : const Spacer(),
                    ...e.map((e) => e.duration == 0
                        ? Expanded(
                            flex: 2,
                            child:
                                Container(color: Colors.red, child: Text('')))
                        : Expanded(
                            flex: 2 * e.duration,
                            child: WeeklyAllDayCell(e.summary,
                                overflow: e.overflow),
                          ))
                  ]))
              .toList()),
      duration: const Duration(microseconds: 250),
    );
  }
}

class DragTaskTarget extends StatelessWidget {
  const DragTaskTarget({super.key});

  @override
  Widget build(BuildContext context) {
    Widget widget = Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(),
          color: Colors.amber[200]),
      child: null,
    );
    return DragTarget<String>(
      onAcceptWithDetails: (task) {
        debugPrint('*Accepted: ${task.data}!!!');
        widget = WeeklyAllDayCell(task.data);
      },
      onWillAcceptWithDetails: (task) {
        debugPrint('*Accept: ${task.data}!!');
        widget = WeeklyAllDayCell(task.data);
        return true;
      },
      onMove: (task) => widget = WeeklyAllDayCell(task.data),
      builder: (context, a, b) {
        debugPrint('a: $a');
        debugPrint('b: $b');
        return widget;
      },
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
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(),
          color: Colors.amber[200]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(summary,
                  softWrap: true, overflow: TextOverflow.fade, maxLines: 1)),
          Text(overflow == null ? '' : '$overflow >>'),
        ],
      ),
    );
  }
}
