import 'event.dart';

sealed class Message {
  const Message();
}

final class AddEvents extends Message {
  const AddEvents(this.events);
  final List<Event> events;
}

final class AddEvent extends Message {
  const AddEvent(this.event);
  final Event event;
}

final class RemoveEvents extends Message {
  const RemoveEvents(this.where);
  final bool Function(Event event) where;
}

// final class UpdateEvent extends Message {
//   const UpdateEvent(this.event);
//   final Event event;
// }
