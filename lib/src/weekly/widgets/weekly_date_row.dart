import 'package:flutter/material.dart';

import '../../consts/month_names.dart';
import '../../models/cell.dart';

class WeeklyDateRow extends StatelessWidget {
  const WeeklyDateRow(
      {required this.cells,
      required this.hideMonth,
      required this.callBack,
      super.key});
  final List<DateCell> cells;
  final bool hideMonth;
  final Function callBack;

  @override
  Widget build(BuildContext context) {
    Border? border;
    return Row(
      children: [
        if (!hideMonth)
          Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () => showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101))
                    .then((newDate) =>
                        newDate != null ? callBack(newDate) : null),
                child: Column(children: [
                  Text('${MonthNames.values[cells[0].dateTime.month]}'),
                  if (cells[0].dateTime.month != cells[6].dateTime.month)
                    Text('${MonthNames.values[cells[6].dateTime.month]}'),
                  Text(cells[0].dateTime.year.toString())
                ]),
              )),
        if (hideMonth) const Spacer(flex: 1),
        ...cells.map((cell) => Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  decoration: BoxDecoration(border: border),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(cell.day,
                          softWrap: false, overflow: TextOverflow.fade),
                      const SizedBox(height: 3.0),
                      Text(
                        cell.date,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
