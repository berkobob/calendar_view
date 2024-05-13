import 'package:flutter/material.dart';

import '../../consts/constants.dart';

class WeeklyDateRow extends StatelessWidget {
  const WeeklyDateRow(
      {required this.monday,
      required this.hideMonth,
      required this.callBack,
      super.key});
  final DateTime monday;
  final bool hideMonth;
  final Function callBack;

  @override
  Widget build(BuildContext context) {
    final sunday = monday.add(const Duration(days: 6));
    Border? border;
    return Row(children: [
      if (!hideMonth)
        Expanded(
            flex: 1,
            child: TextButton(
              onPressed: () => showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101))
                  .then(
                      (newDate) => newDate != null ? callBack(newDate) : null),
              child: Column(children: [
                Text('${MonthNames.values[monday.month]}'),
                if (monday.month != sunday.month)
                  Text('${MonthNames.values[sunday.month]}'),
                Text(monday.year.toString())
              ]),
            )),
      if (hideMonth) const Spacer(flex: 1),
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
