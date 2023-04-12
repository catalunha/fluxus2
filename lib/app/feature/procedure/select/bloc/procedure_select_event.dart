abstract class ProcedureSelectEvent {}

class ProcedureSelectEventNextPage extends ProcedureSelectEvent {}

class ProcedureSelectEventPreviousPage extends ProcedureSelectEvent {}

class ProcedureSelectEventStartQuery extends ProcedureSelectEvent {}

class ProcedureSelectEventFormSubmitted extends ProcedureSelectEvent {
  final String name;
  ProcedureSelectEventFormSubmitted(this.name);
}
