import '../../../../core/models/office_model.dart';

abstract class OfficeSelectEvent {}

class OfficeSelectEventNextPage extends OfficeSelectEvent {}

class OfficeSelectEventPreviousPage extends OfficeSelectEvent {}

class OfficeSelectEventStartQuery extends OfficeSelectEvent {}

class OfficeSelectEventFormSubmitted extends OfficeSelectEvent {
  final String name;
  OfficeSelectEventFormSubmitted(this.name);
}

class OfficeSelectEventUpdateSelectedValues extends OfficeSelectEvent {
  final OfficeModel model;
  OfficeSelectEventUpdateSelectedValues(
    this.model,
  );
}
