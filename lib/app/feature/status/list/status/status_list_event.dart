import '../../../../core/models/Status_model.dart';

abstract class StatusListEvent {}

class StatusListEventNextPage extends StatusListEvent {}

class StatusListEventPreviousPage extends StatusListEvent {}

class StatusListEventAddToList extends StatusListEvent {
  final StatusModel model;
  StatusListEventAddToList(
    this.model,
  );
}

class StatusListEventUpdateList extends StatusListEvent {
  final StatusModel model;
  StatusListEventUpdateList(
    this.model,
  );
}

class StatusListEventRemoveFromList extends StatusListEvent {
  final String id;
  StatusListEventRemoveFromList(
    this.id,
  );
}

class StatusListEventInitialList extends StatusListEvent {}
