import '../../../../core/models/room_model.dart';

abstract class RoomListEvent {}

class RoomListEventNextPage extends RoomListEvent {}

class RoomListEventPreviousPage extends RoomListEvent {}

class RoomListEventAddToList extends RoomListEvent {
  final RoomModel model;
  RoomListEventAddToList(
    this.model,
  );
}

class RoomListEventUpdateList extends RoomListEvent {
  final RoomModel model;
  RoomListEventUpdateList(
    this.model,
  );
}

class RoomListEventRemoveFromList extends RoomListEvent {
  final String id;
  RoomListEventRemoveFromList(
    this.id,
  );
}

class RoomListEventInitialList extends RoomListEvent {}
