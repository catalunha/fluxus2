abstract class HealthPlanTypeSaveEvent {}

class HealthPlanTypeSaveEventDelete extends HealthPlanTypeSaveEvent {}

class HealthPlanTypeSaveEventFormSubmitted extends HealthPlanTypeSaveEvent {
  final String? name;
  HealthPlanTypeSaveEventFormSubmitted({
    this.name,
  });
}
