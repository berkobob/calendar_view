import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../consts/month_names.dart';
import '../controllers/weekly_controller.dart';

class WeeklyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const WeeklyAppBar({required this.date, super.key})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  final DateTime date;

  @override
  State<WeeklyAppBar> createState() => _WeeklyAppBarState();

  @override
  final Size preferredSize;
}

class _WeeklyAppBarState extends State<WeeklyAppBar> {
  final pageController = di.get<WeeklyController>().pageController;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () => showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101))
              .then((newDate) => newDate != null
                  ? _toPage(20)
                  // ? _toPage(controller.pageNumberFromDate(newDate))
                  : null),
          icon: const Icon(Icons.calendar_month)),
      title: _appBarTitleCell(widget.date),
      actions: [
        IconButton(
            onPressed: () => _toPage(0), icon: const Icon(Icons.first_page)),
        IconButton(
            onPressed: _pageBack, icon: const Icon(Icons.arrow_back_ios)),
        IconButton(
            onPressed: () => _toPage(10),
            // _toPage(controller.pageNumberFromDate(DateTime.now())),
            icon: const Icon(Icons.today)),
        IconButton(
            onPressed: _pageForward, icon: const Icon(Icons.arrow_forward_ios)),
      ],
    );
  }

  void _pageBack() {
    pageController.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn);
  }

  void _pageForward() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn);
  }

  void _toPage(int page) {
    pageController.animateToPage(page,
        duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn);
  }

  Widget _appBarTitleCell(DateTime start) {
    final end = start.add(const Duration(days: 7));
    if (start.month == end.month) {
      return Text('${MonthNames.values[start.month]}, ${start.year}');
    }
    if (start.year == end.year) {
      return Text(
          '${MonthNames.values[start.month]} - ${MonthNames.values[end.month]}, ${start.year}');
    }
    return Text(
        '${MonthNames.values[start.month]}, ${start.year} - ${MonthNames.values[end.month]}, ${end.year}');
  }
}
