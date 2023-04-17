import '../../../../core/models/status_model.dart';

abstract class StatusSelectEvent {}

class StatusSelectEventNextPage extends StatusSelectEvent {}

class StatusSelectEventPreviousPage extends StatusSelectEvent {}

class StatusSelectEventStartQuery extends StatusSelectEvent {}

class StatusSelectEventFormSubmitted extends StatusSelectEvent {
  final String name;
  StatusSelectEventFormSubmitted(this.name);
}

class StatusSelectEventUpdateSelectedValues extends StatusSelectEvent {
  final StatusModel model;
  StatusSelectEventUpdateSelectedValues(
    this.model,
  );
}
