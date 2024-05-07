import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../controllers/weekly_controller.dart';
import 'widgets/weekly_widgets.dart';

class WeeklyView extends StatefulWidget {
  const WeeklyView({super.key});

  @override
  State<WeeklyView> createState() => _WeeklyViewState();
}

class _WeeklyViewState extends State<WeeklyView> {
  late PageController pageController;
  final WeeklyController controller = di.get<WeeklyController>();

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _toPage(int page) {
    setState(() {
      pageController.animateToPage(page,
          duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn);
    });
  }

  void _pageBack() {
    setState(() {
      pageController.animateToPage(pageController.page!.toInt() - 1,
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn);
    });
  }

  void _pageForward() {
    setState(() {
      pageController.animateToPage(pageController.page!.toInt() + 1,
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemBuilder: (BuildContext context, int pageNumber) => Scaffold(
        appBar: controller.showAppBar
            ? AppBar(
                leading: IconButton(
                    onPressed: () => showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101))
                        .then((newDate) => newDate != null
                            ? _toPage(controller.pageNumberFromDate(newDate))
                            : null),
                    icon: const Icon(Icons.calendar_month)),
                title:
                    AppBarTitleCell(controller.dateFromPageNumber(pageNumber)),
                actions: [
                  IconButton(
                      onPressed: () => _toPage(0),
                      icon: const Icon(Icons.first_page)),
                  IconButton(
                      onPressed: _pageBack,
                      icon: const Icon(Icons.arrow_back_ios)),
                  IconButton(
                      onPressed: () => _toPage(
                          controller.pageNumberFromDate(DateTime.now())),
                      icon: const Icon(Icons.today)),
                  IconButton(
                      onPressed: _pageForward,
                      icon: const Icon(Icons.arrow_forward_ios)),
                ],
              )
            : null,
        body: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    WeeklyDateRow(
                        cells: controller.getDatesRow(pageNumber),
                        hideMonth: controller.showAppBar,
                        callBack: (DateTime newDate) =>
                            _toPage(controller.pageNumberFromDate(newDate))),
                    const Divider(),
                    WeeklyAllDayEvents(
                        events: controller.getAlldayEvents(pageNumber)),
                  ],
                ),
                Positioned.fill(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(flex: 1),
                      ...List.generate(
                          7,
                          (day) => Expanded(
                              flex: 2,
                              child: TaskTarget(
                                  date: controller
                                      .dateFromPageNumber(pageNumber)
                                      .add(Duration(days: day))
                                  // color: Colors.red,
                                  )))
                    ],
                  ),
                )
              ],
            ),
            WeeklyCalendar(pageNumber),
          ],
        ),
      ),
    );
  }
}

class TaskTarget extends StatelessWidget {
  const TaskTarget({super.key, required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    BoxBorder? border;
    return DragTarget<String>(
      builder: (context, _, __) => Container(
        decoration: BoxDecoration(
            border: border, borderRadius: BorderRadius.circular(10.0)),
      ),
      onWillAcceptWithDetails: (task) {
        border = Border.all(color: Theme.of(context).primaryColor);
        return true;
      },
      onAcceptWithDetails: (task) {
        border = null;
        debugPrint('Accepted ${task.data} on $date!');
      },
      onLeave: (data) => border = null,
    );
  }
}

// class DragTaskTarget extends StatelessWidget {
//   const DragTaskTarget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final Widget taskTarget = Container(
//       margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5),
//       padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
//       child: const Text('hi'),
//     );
//     Widget widget = taskTarget;
//     return DragTarget<String>(
//       onAcceptWithDetails: (task) {
//         debugPrint('*Accepted: ${task.data}!!! on ');
//       },
//       onWillAcceptWithDetails: (task) {
//         widget = Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Theme.of(context).primaryColor),
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           child: const Text(''),
//         );
//         return true;
//       },
//       builder: (context, a, b) => widget,
//       onLeave: (data) => widget = taskTarget,
//     );
//   }
// }
