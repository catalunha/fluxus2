import 'package:fluxus2/app/core/models/expertise_model.dart';

abstract class ProcedureSaveEvent {}

class ProcedureSaveEventDelete extends ProcedureSaveEvent {}

class ProcedureSaveEventFormSubmitted extends ProcedureSaveEvent {
  final String? name;
  final String? code;
  final double? cost;
  ProcedureSaveEventFormSubmitted({
    required this.name,
    this.code,
    this.cost,
  });
}

class ProcedureSaveEventAddExpertise extends ProcedureSaveEvent {
  final ExpertiseModel model;
  ProcedureSaveEventAddExpertise(this.model);
}
