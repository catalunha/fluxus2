import '../../../../core/models/procedure_model.dart';

abstract class ProcedureSearchEvent {}

class ProcedureSearchEventNextPage extends ProcedureSearchEvent {}

class ProcedureSearchEventPreviousPage extends ProcedureSearchEvent {}

class ProcedureSearchEventUpdateList extends ProcedureSearchEvent {
  final ProcedureModel model;
  ProcedureSearchEventUpdateList(
    this.model,
  );
}

class ProcedureSearchEventRemoveFromList extends ProcedureSearchEvent {
  final String modelId;
  ProcedureSearchEventRemoveFromList(
    this.modelId,
  );
}

class ProcedureSearchEventFormSubmitted extends ProcedureSearchEvent {
  final bool nameContainsBool;
  final String nameContainsString;
  final bool codeEqualsToBool;
  final String codeEqualsToString;
  ProcedureSearchEventFormSubmitted({
    required this.nameContainsBool,
    required this.nameContainsString,
    required this.codeEqualsToBool,
    required this.codeEqualsToString,
  });
}
