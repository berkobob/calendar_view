import 'event.dart';

sealed class Message {}

final class AddEvents extends Message {
  AddEvents(this.events);
  final List<Event> events;
}

final class AddEvent extends Message {
  AddEvent(this.event);
  final Event event;
}

final class RemoveEvents extends Message {
  RemoveEvents(this.where);
  final bool Function(Event event) where;
}
