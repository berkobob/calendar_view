import 'package:calendar_view/src/models/all_day_event.dart';
import 'package:flutter/material.dart';

class WeeklyAllDayCell extends StatelessWidget {
  const WeeklyAllDayCell(this.allDayEvent, {super.key});
  final AllDayEvent allDayEvent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: Draggable<String>(
          data: allDayEvent.summary,
          // onDragStarted: () => print('onDragStarted'),
          // onDragUpdate: print,
          feedback: SizedBox(
              width: constraints.maxWidth,
              child: Material(
                child: WeeklyAllDayEventCell(allDayEvent),
              )),
          childWhenDragging: SizedBox(
            width: constraints.maxWidth,
            child: Opacity(
              opacity: 0.5,
              child: WeeklyAllDayEventCell(allDayEvent),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5),
            child: WeeklyAllDayEventCell(allDayEvent),
          ),
        ),
      ),
    );
  }
}

class WeeklyAllDayEventCell extends StatelessWidget {
  const WeeklyAllDayEventCell(this.allDayEvent, {super.key});

  final AllDayEvent allDayEvent;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular((allDayEvent.underflow ?? 0) > 0 ? 0 : 10.0),
            right: Radius.circular((allDayEvent.overflow ?? 0) > 0 ? 0 : 10.0),
          ),
          border: Border(
            top: const BorderSide(),
            bottom: const BorderSide(),
            left: (allDayEvent.underflow ?? 0) > 0
                ? BorderSide.none
                : const BorderSide(),
            right: (allDayEvent.overflow ?? 0) > 0
                ? BorderSide.none
                : const BorderSide(),
          ),
          color: Colors.amber[200]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text((allDayEvent.underflow ?? 0) > 0
              ? '${allDayEvent.underflow} << '
              : ''),
          Expanded(
              child: Text(allDayEvent.summary,
                  softWrap: true, overflow: TextOverflow.fade, maxLines: 1)),
          Text((allDayEvent.overflow ?? 0) > 0
              ? '>> ${allDayEvent.overflow}'
              : ''),
        ],
      ),
    );
  }
}
