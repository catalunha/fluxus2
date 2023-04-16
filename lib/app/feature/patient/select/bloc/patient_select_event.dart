import '../../../../core/models/patient_model.dart';

abstract class PatientSelectEvent {}

class PatientSelectEventNextPage extends PatientSelectEvent {}

class PatientSelectEventPreviousPage extends PatientSelectEvent {}

class PatientSelectEventStartQuery extends PatientSelectEvent {}

class PatientSelectEventFormSubmitted extends PatientSelectEvent {
  final String name;
  PatientSelectEventFormSubmitted(this.name);
}

class PatientSelectEventUpdateSelectedValues extends PatientSelectEvent {
  final PatientModel model;
  PatientSelectEventUpdateSelectedValues(
    this.model,
  );
}
