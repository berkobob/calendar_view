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
                    MainView(events: snapshot.data as List<Event>),
                }),
      ),
    ),
  );
}

class MainView extends StatelessWidget {
  const MainView({super.key, required this.events});
  final List<Event> events;

  @override
  Widget build(BuildContext context) {
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
          child: CalendarView(
            view: CalendarViews.weekly,
            events: events,
            initDate: DateTime(2024, 3, 4),
            // showAppBar: true,
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
    return Draggable<String>(
        data: task,
        feedback: ConstrainedBox(
            constraints: BoxConstraints.loose(const Size(150, 75)),
            child: Opacity(
              opacity: 0.5,
              child: Material(
                child: child,
              ),
            )),
        childWhenDragging: const ListTile(),
        onDragEnd: (DraggableDetails details) =>
            debugPrint('Drag ended with: ${details.wasAccepted}'),
        onDragCompleted: () => debugPrint('Drag completed of $child'),
        child: child);
  }
}

Future<List<Event>> loadData() async {
  final data = await rootBundle.loadString('assets/data.json');
  final json = jsonDecode(data);
  return json['items']
      .where((x) => x['status'] == 'confirmed')
      .map<Event>((x) => Event.fromJson(x, calendar: 'Test Calendar'))
      .toList()
    ..sort();
}
