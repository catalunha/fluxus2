import '../../../../core/models/healthplantype_model.dart';

abstract class HealthPlanSaveEvent {}

class HealthPlanSaveEventDelete extends HealthPlanSaveEvent {}

class HealthPlanSaveEventFormSubmitted extends HealthPlanSaveEvent {
  final String? code;
  final DateTime? due;
  final String? description;
  HealthPlanSaveEventFormSubmitted({
    this.code,
    this.due,
    this.description,
  });
}

class HealthPlanSaveEventAddHealthPlanType extends HealthPlanSaveEvent {
  final HealthPlanTypeModel model;
  HealthPlanSaveEventAddHealthPlanType(this.model);
}
