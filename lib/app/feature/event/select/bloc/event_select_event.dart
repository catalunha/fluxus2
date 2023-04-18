import '../../../../core/models/event_model.dart';

abstract class EventSelectEvent {}

class EventSelectEventNextPage extends EventSelectEvent {}

class EventSelectEventPreviousPage extends EventSelectEvent {}

class EventSelectEventStartQuery extends EventSelectEvent {}

class EventSelectEventFormSubmitted extends EventSelectEvent {
  final String id;
  EventSelectEventFormSubmitted(this.id);
}

class EventSelectEventUpdateSelectedValues extends EventSelectEvent {
  final EventModel model;
  EventSelectEventUpdateSelectedValues(
    this.model,
  );
}
