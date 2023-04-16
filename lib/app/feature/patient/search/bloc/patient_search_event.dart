import '../../../../core/models/patient_model.dart';

abstract class PatientSearchEvent {}

class PatientSearchEventNextPage extends PatientSearchEvent {}

class PatientSearchEventPreviousPage extends PatientSearchEvent {}

class PatientSearchEventUpdateList extends PatientSearchEvent {
  final PatientModel model;
  PatientSearchEventUpdateList(
    this.model,
  );
}

class PatientSearchEventRemoveFromList extends PatientSearchEvent {
  final PatientModel model;
  PatientSearchEventRemoveFromList(
    this.model,
  );
}

class PatientSearchEventFormSubmitted extends PatientSearchEvent {
  final bool nameContainsBool;
  final String nameContainsString;
  final bool cpfEqualToBool;
  final String cpfEqualToString;
  final bool phoneEqualToBool;
  final String phoneEqualToString;
  PatientSearchEventFormSubmitted({
    required this.nameContainsBool,
    required this.nameContainsString,
    required this.cpfEqualToBool,
    required this.cpfEqualToString,
    required this.phoneEqualToBool,
    required this.phoneEqualToString,
  });
}
