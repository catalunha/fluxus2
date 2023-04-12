import '../../../../core/models/expertise_model.dart';

abstract class ExpertiseListEvent {}

class ExpertiseListEventNextPage extends ExpertiseListEvent {}

class ExpertiseListEventPreviousPage extends ExpertiseListEvent {}

class ExpertiseListEventUpdateList extends ExpertiseListEvent {
  final ExpertiseModel model;
  ExpertiseListEventUpdateList(
    this.model,
  );
}

class ExpertiseListEventRemoveFromList extends ExpertiseListEvent {
  final String id;
  ExpertiseListEventRemoveFromList(
    this.id,
  );
}

class ExpertiseListEventInitialList extends ExpertiseListEvent {}
