import 'package:flutter/material.dart';

import '../../models/models.dart';

class WeeklyAllDayCell extends StatelessWidget {
  const WeeklyAllDayCell(this.allDayEvent, {super.key});
  final AllDayEvent allDayEvent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: Draggable<Event>(
          data: allDayEvent.event,
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
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(allDayEvent.underflow > 0 ? 0 : 10.0),
            right: Radius.circular(allDayEvent.overflow > 0 ? 0 : 10.0),
          ),
          border: Border(
            top: const BorderSide(width: 0.5),
            bottom: const BorderSide(width: 0.5),
            left: allDayEvent.underflow > 0
                ? BorderSide.none
                : const BorderSide(width: 0.5),
            right: allDayEvent.overflow > 0
                ? BorderSide.none
                : const BorderSide(width: 0.5),
          ),
          color: Colors.amber[200]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(allDayEvent.underflow > 0 ? '${allDayEvent.underflow} << ' : ''),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (allDayEvent.summary.replaceAll('☐ ', '') !=
                    allDayEvent.summary)
                  Transform.scale(
                    scale: 0.75,
                    child: Checkbox(value: false, onChanged: (_) {}),
                  ),
                Expanded(
                  child: Text(
                    allDayEvent.summary.replaceAll('☐ ', ''),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Text(allDayEvent.overflow > 0 ? '>> ${allDayEvent.overflow}' : ''),
        ],
      ),
    );
  }
}
