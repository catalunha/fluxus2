abstract class RoomSaveEvent {}

class RoomSaveEventDelete extends RoomSaveEvent {}

class RoomSaveEventFormSubmitted extends RoomSaveEvent {
  final String? name;
  final bool? isActive;
  RoomSaveEventFormSubmitted({
    this.name,
    this.isActive,
  });
}
