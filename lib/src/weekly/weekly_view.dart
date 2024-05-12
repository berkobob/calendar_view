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
      pageController.previousPage(
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn);
    });
  }

  void _pageForward() {
    setState(() {
      pageController.nextPage(
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<BoxBorder?> border = List.generate(7, (index) => null);
    return PageView.builder(
      controller: pageController,
      itemBuilder: (BuildContext context, int pageNumber) {
        final date = controller.dateFromPageNumber(pageNumber);
        return Scaffold(
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
                  title: AppBarTitleCell(date),
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
                                child: DragTarget<String>(
                                  builder: (context, _, __) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          border: border[day],
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                    );
                                  },
                                  onLeave: (data) => border[day] = null,
                                  onWillAcceptWithDetails: (task) {
                                    border[day] = Border.all(
                                        color: Theme.of(context).primaryColor);
                                    return true;
                                  },
                                  onAcceptWithDetails: (task) {
                                    border[day] = null;
                                    debugPrint(
                                        'Accepted ${task.data} on ${date.add(Duration(days: day))}');
                                  },
                                )))
                      ],
                    ),
                  )
                ],
              ),
              WeeklyScheduledEvents(date),
            ],
          ),
        );
      },
    );
  }
}
