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
                  ConnectionState.done => CalendarView(
                      view: CalendarViews.weekly,
                      events: snapshot.data as List<Event>,
                      initialDate: DateTime(2024, 3, 4),
                      showAppBar: false,
                      showTimeLine: true,
                    )
                }),
      ),
    ),
  );
}

Future<List<Event>> loadData() async {
  final data = await rootBundle.loadString('assets/data.json');
  final json = jsonDecode(data);
  return json['items']
      .where((x) => x['status'] == 'confirmed')
      .map<Event>((x) => Event.fromJson(x, calendar: 'Test Calendar'))
      .toList()
    ..sort();
  // ..forEach(print);
}
