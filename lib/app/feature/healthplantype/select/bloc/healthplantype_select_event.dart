import '../../../../core/models/healthplantype_model.dart';

abstract class HealthPlanTypeSelectEvent {}

class HealthPlanTypeSelectEventNextPage extends HealthPlanTypeSelectEvent {}

class HealthPlanTypeSelectEventPreviousPage extends HealthPlanTypeSelectEvent {}

class HealthPlanTypeSelectEventStartQuery extends HealthPlanTypeSelectEvent {}

class HealthPlanTypeSelectEventFormSubmitted extends HealthPlanTypeSelectEvent {
  final String name;
  HealthPlanTypeSelectEventFormSubmitted(this.name);
}

class HealthPlanTypeSelectEventUpdateSelectedValues
    extends HealthPlanTypeSelectEvent {
  final HealthPlanTypeModel model;
  HealthPlanTypeSelectEventUpdateSelectedValues(
    this.model,
  );
}
