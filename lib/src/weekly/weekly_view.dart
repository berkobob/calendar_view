import 'package:calendar_view/src/weekly/widgets/title_cell.dart';
import 'package:flutter/material.dart';

import '../controllers/controller.dart';
import 'widgets/weekly_allday_events.dart';
import 'widgets/weekly_calendar.dart';
import 'widgets/weekly_date_row.dart';

class WeeklyView extends StatefulWidget {
  const WeeklyView(
      {required this.controller,
      required this.showAppBar,
      required this.showTimeLine,
      super.key});

  final Controller controller;
  final bool showAppBar;
  final bool showTimeLine;

  @override
  State<WeeklyView> createState() => _WeeklyViewState();
}

class _WeeklyViewState extends State<WeeklyView> {
  late PageController pageController;

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
      itemBuilder: (BuildContext context, int weekIndex) => Scaffold(
        appBar: widget.showAppBar
            ? AppBar(
                leading: IconButton(
                    onPressed: () => _toPage(widget.controller
                        .pageNumberFromDate(DateTime(2024, 4, 16))),
                    icon: const Icon(Icons.calendar_month)),
                title:
                    TitleCell(widget.controller.dateFromPageNumber(weekIndex)),
                actions: [
                  IconButton(
                      onPressed: () => _toPage(0),
                      icon: const Icon(Icons.first_page)),
                  IconButton(
                      onPressed: _pageBack,
                      icon: const Icon(Icons.arrow_back_ios)),
                  IconButton(
                      onPressed: () => _toPage(
                          widget.controller.pageNumberFromDate(DateTime.now())),
                      icon: const Icon(Icons.today)),
                  IconButton(
                      onPressed: _pageForward,
                      icon: const Icon(Icons.arrow_forward_ios)),
                ],
              )
            : null,
        body: Column(
          children: [
            WeeklyDateRow(
                cells: widget.controller.getDaysRow(weekIndex),
                hideMonth: widget.showAppBar),
            const Divider(),
            // WeeklyMultidayEvents(
            //     events: controller.getMultidayEvents(week: 10, year: 2024)),
            WeeklyAlldayEvents(
                events:
                    widget.controller.getAlldayEvents(week: 10, year: 2024)),
            // WeeklyCalendar(controller.getEvents(week: 10, year: 2024)),
            WeeklyCalendar(widget.controller.getEvents(weekIndex),
                showTimeLine: widget.showTimeLine),
          ],
        ),
      ),
    );
  }
}
