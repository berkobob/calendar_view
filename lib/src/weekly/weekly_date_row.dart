import 'package:calendar_view/src/weekly/weely_all_day_events/weekly_all_day_drop_target.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../consts/constants.dart';
import '../controllers/weekly_controller.dart';

class WeeklyDateRow extends StatelessWidget with WatchItMixin {
  const WeeklyDateRow({super.key});

  @override
  Widget build(BuildContext context) {
    final wc = di.get<WeeklyController>();
    final monday =
        watchPropertyValue<WeeklyController, DateTime>((c) => c.monday);
    final sunday = monday.add(const Duration(days: 6));
    final showMonth = !wc.showAppBar;
    Border? border;

    return Row(children: [
      if (showMonth)
        Expanded(
            flex: 1,
            child: TextButton(
              onPressed: () => showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101))
                  .then((newDate) => newDate != null
                      ? wc.pageController.animateToPage(
                          wc.pageNumberFromDate(newDate),
                          duration: const Duration(seconds: 2),
                          curve: Curves.fastOutSlowIn)
                      : null),
              child: Column(children: [
                Text('${MonthNames.values[monday.month]}'),
                if (monday.month != sunday.month)
                  Text('${MonthNames.values[sunday.month]}'),
                Text(monday.year.toString())
              ]),
            )),
      if (!showMonth) const Spacer(flex: 1),
      ...List.generate(7, (day) => monday.add(Duration(days: day)))
          .map((today) => Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    decoration: BoxDecoration(border: border),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('${DaysOfWeek.values[today.weekday]}',
                              softWrap: false, overflow: TextOverflow.fade),
                          const SizedBox(height: 3.0),
                          Text(
                            '${today.day}',
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ]),
                  ),
                ),
              ))
    ]);
  }
}
