import '../../../../core/models/office_model.dart';

abstract class OfficeListEvent {}

class OfficeListEventNextPage extends OfficeListEvent {}

class OfficeListEventPreviousPage extends OfficeListEvent {}

class OfficeListEventAddToList extends OfficeListEvent {
  final OfficeModel model;
  OfficeListEventAddToList(
    this.model,
  );
}

class OfficeListEventUpdateList extends OfficeListEvent {
  final OfficeModel model;
  OfficeListEventUpdateList(
    this.model,
  );
}

class OfficeListEventRemoveFromList extends OfficeListEvent {
  final String id;
  OfficeListEventRemoveFromList(
    this.id,
  );
}

class OfficeListEventInitialList extends OfficeListEvent {}
