import 'package:flutter/material.dart';

import '../../models/cell.dart';

class WeeklyMultidayEvents extends StatelessWidget {
  const WeeklyMultidayEvents({required this.events, super.key});
  final List<MultidayCell> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Spacer(flex: 1),
        ...events.map((event) => Row(
              children: [
                // Spacer(flex: 2 * event.date.weekday),
                Expanded(flex: 2 * (event.days), child: Text(event.summary)),
              ],
            ))
      ],
    );
  }
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Expanded(flex: 1, child: Text('spare')),
//         ...events.map((event) => Expanded(
//               flex: 2 * event[0].days,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: event
//                     .map<Container>((e) => Container(
//                           margin: const EdgeInsets.symmetric(
//                               horizontal: 5.0, vertical: 2.5),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 4.0, vertical: 2.0),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10.0),
//                               border: Border.all(),
//                               color: Colors.amber[200]),
//                           child: Text(e.summary,
//                               softWrap: false, overflow: TextOverflow.fade),
//                         ))
//                     .toList(),
//               ),
//             )),
//       ],
//     );
//   }
}
