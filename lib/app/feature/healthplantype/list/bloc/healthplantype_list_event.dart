import '../../../../core/models/healthplantype_model.dart';

abstract class HealthPlanTypeListEvent {}

class HealthPlanTypeListEventNextPage extends HealthPlanTypeListEvent {}

class HealthPlanTypeListEventPreviousPage extends HealthPlanTypeListEvent {}

class HealthPlanTypeListEventAddToList extends HealthPlanTypeListEvent {
  final HealthPlanTypeModel model;
  HealthPlanTypeListEventAddToList(
    this.model,
  );
}

class HealthPlanTypeListEventUpdateList extends HealthPlanTypeListEvent {
  final HealthPlanTypeModel model;
  HealthPlanTypeListEventUpdateList(
    this.model,
  );
}

class HealthPlanTypeListEventRemoveFromList extends HealthPlanTypeListEvent {
  final String id;
  HealthPlanTypeListEventRemoveFromList(
    this.id,
  );
}

class HealthPlanTypeListEventInitialList extends HealthPlanTypeListEvent {}
