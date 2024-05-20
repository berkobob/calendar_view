import 'dart:convert';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

List<CVEvent> allEvents = [];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Calendar View Example'),
        ),
        body: FutureBuilder(
            future: loadData(),
            builder: (context, snapshot) => switch (snapshot.connectionState) {
                  ConnectionState.waiting ||
                  ConnectionState.none ||
                  ConnectionState.active =>
                    const Center(child: CircularProgressIndicator()),
                  ConnectionState.done =>
                    MainView(events: snapshot.data as List<CVEvent>),
                }),
      ),
    ),
  );

  Future.delayed(const Duration(seconds: 5), () {
    EventsController.events.add(allEvents);
  });

  Future.delayed(const Duration(seconds: 10), () {
    debugPrint('Lets try this');
    EventsController.events.add([
      CVEvent(
          summary: 'IT WORKED',
          isAllDay: false,
          start: DateTime(2024, 03, 07, 08),
          end: DateTime(2024, 03, 07, 09))
    ]);
  });
}

class MainView extends StatelessWidget {
  const MainView({super.key, required this.events});
  final List<CVEvent> events;

  @override
  Widget build(BuildContext context) {
    allEvents = events;
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: ListView(children: const [
              DraggableTask(task: 'Task no 1'),
              DraggableTask(task: 'Task no 2'),
              DraggableTask(task: 'Task no 3'),
              DraggableTask(task: 'Task no 4'),
              DraggableTask(task: 'Task no 5'),
            ])),
        Expanded(
          flex: 7,
          child: CVCalendar(
            view: CalendarView.weekly,
            // events: events,
            initDate: DateTime(2024, 3, 4),
            showAppBar: true,
            autoScroll: true,
            // showTimeLine: true,
          ),
        ),
      ],
    );
  }
}

class DraggableTask extends StatelessWidget {
  const DraggableTask({super.key, required this.task});
  final String task;

  @override
  Widget build(BuildContext context) {
    final Widget child = ListTile(title: Text(task));
    return Draggable<Task>(
        data: Task(summary: task),
        feedback: ConstrainedBox(
            constraints: BoxConstraints.loose(const Size(150, 75)),
            child: Opacity(
              opacity: 0.5,
              child: Material(
                child: child,
              ),
            )),
        childWhenDragging: const ListTile(),
        onDragEnd: (DraggableDetails details) => debugPrint(
            'Drag ended with: ${details.wasAccepted}. Remove $child from list.'),
        // onDragCompleted: () => debugPrint('Drag completed of $child'),
        child: child);
  }
}

Future<List<CVEvent>> loadData() async {
  final data = await rootBundle.loadString('assets/data.json');
  final json = jsonDecode(data);
  return json['items']
      .where((x) => x['status'] == 'confirmed')
      .map<CVEvent>((x) {
    x['calendar'] = 'Test Calendar';
    return CVEvent.fromJson(x);
  }).toList()
    ..sort();
}
