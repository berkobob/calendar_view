library calendar_view;

/// # Calendar View
/// The calendar_view library provides a set of widgets and controllers to
/// display and manage calendar views in a Flutter application. It supports
/// various views such as daily, weekly, monthly, yearly, agenda, and schedule.
///
/// ## Getting Started
/// To use the calendar_view library, you need to add it as a dependency in your
/// pubspec.yaml file:
///
/// ```yaml
/// dependencies:
///   calendar_view: ^1.0.0
/// ```
/// Then, run flutter pub get to fetch the package.
///
/// ## Usage
/// To use the calendar_view library, you need to import the necessary packages:
///
/// ```import 'package:calendar_view/calendar_view.dart';```
///
/// and instantiate the main widget, CVCalendar, which is responsible
/// for rendering the calendar view. There are no required parameters but
/// consider passing a view parameter to specify the type of view to display.
///
/// ```dart
/// CalendarView.daily,
/// CalendarView.weekly,
/// CalendarView.fiveDays,
/// CalendarView.monthly,
/// CalendarView.yearly,
/// CalendarView.agenda,
/// CalendarView.schedule,
/// CalendarView.```

export 'src/consts/constants.dart';
export 'src/weekly/weekly_view.dart';
export 'src/models/event_interface.dart';
export 'src/models/events_messages.dart';
export 'src/main.dart';
export 'src/controllers/events_controller.dart';
