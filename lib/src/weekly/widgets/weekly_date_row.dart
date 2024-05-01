import 'package:flutter/material.dart';

import '../../consts/month_names.dart';
import '../../models/cell.dart';

class WeeklyDateRow extends StatelessWidget {
  const WeeklyDateRow({required this.cells, super.key});
  final List<DateCell> cells;

  @override
  Widget build(BuildContext context) {
    print(
        '${cells[0].dateTime.month}  ${cells[6].dateTime.month} ${cells[0].dateTime.month != cells[6].dateTime.month}');
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Column(children: [
              Text('${MonthNames.values[cells[0].dateTime.month]}'),
              if (cells[0].dateTime.month != cells[6].dateTime.month)
                Text('${MonthNames.values[cells[6].dateTime.month]}'),
              Text(cells[0].dateTime.year.toString())
            ])),
        ...cells.map((cell) => Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(cell.day, softWrap: false, overflow: TextOverflow.fade),
                  const SizedBox(height: 6.0),
                  Text(
                    cell.date,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
