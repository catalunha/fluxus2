import '../../../../core/models/graduation_model.dart';

abstract class GraduationListEvent {}

class GraduationListEventNextPage extends GraduationListEvent {}

class GraduationListEventPreviousPage extends GraduationListEvent {}

class GraduationListEventAddToList extends GraduationListEvent {
  final GraduationModel model;
  GraduationListEventAddToList(
    this.model,
  );
}

class GraduationListEventUpdateList extends GraduationListEvent {
  final GraduationModel model;
  GraduationListEventUpdateList(
    this.model,
  );
}

class GraduationListEventRemoveFromList extends GraduationListEvent {
  final String id;
  GraduationListEventRemoveFromList(
    this.id,
  );
}

class GraduationListEventInitialList extends GraduationListEvent {}