import '../../../../core/models/graduation_model.dart';

abstract class GraduationListEvent {}

class GraduationListEventNextPage extends GraduationListEvent {}

class GraduationListEventPreviousPage extends GraduationListEvent {}

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
