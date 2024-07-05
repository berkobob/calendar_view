import 'event.dart';

sealed class Message {
  const Message();
}

final class AddEvents extends Message {
  const AddEvents(this.events);
  final Iterable<CVEvent> events;
}

final class AddEvent extends Message {
  const AddEvent(this.event);
  final CVEvent event;
}

final class RemoveEvents extends Message {
  const RemoveEvents(this.where);
  final bool Function(CVEvent event) where;
}

// final class UpdateEvent extends Message {
//   const UpdateEvent(this.event);
//   final Event event;
// }
