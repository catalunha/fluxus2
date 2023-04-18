import '../../../../core/models/event_model.dart';

abstract class EventSearchEvent {}

class EventSearchEventNextPage extends EventSearchEvent {}

class EventSearchEventPreviousPage extends EventSearchEvent {}

class EventSearchEventUpdateList extends EventSearchEvent {
  final EventModel model;
  EventSearchEventUpdateList(
    this.model,
  );
}

class EventSearchEventRemoveFromList extends EventSearchEvent {
  final EventModel model;
  EventSearchEventRemoveFromList(
    this.model,
  );
}

class EventSearchEventFormSubmitted extends EventSearchEvent {}
