import '../../../../core/models/room_model.dart';

abstract class RoomSelectEvent {}

class RoomSelectEventNextPage extends RoomSelectEvent {}

class RoomSelectEventPreviousPage extends RoomSelectEvent {}

class RoomSelectEventStartQuery extends RoomSelectEvent {}

class RoomSelectEventFormSubmitted extends RoomSelectEvent {
  final String name;
  RoomSelectEventFormSubmitted(this.name);
}

class RoomSelectEventUpdateSelectedValues extends RoomSelectEvent {
  final RoomModel model;
  RoomSelectEventUpdateSelectedValues(
    this.model,
  );
}
