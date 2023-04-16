abstract class RoomSaveEvent {}

class RoomSaveEventDelete extends RoomSaveEvent {}

class RoomSaveEventFormSubmitted extends RoomSaveEvent {
  final String? name;
  RoomSaveEventFormSubmitted({
    this.name,
  });
}
