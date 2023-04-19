import '../../../../core/models/attendance_model.dart';
import '../../../../core/models/patient_model.dart';
import '../../../../core/models/user_profile_model.dart';

abstract class AttendanceSearchEvent {}

class AttendanceSearchEventNextPage extends AttendanceSearchEvent {}

class AttendanceSearchEventPreviousPage extends AttendanceSearchEvent {}

class AttendanceSearchEventUpdateList extends AttendanceSearchEvent {
  final AttendanceModel model;
  AttendanceSearchEventUpdateList(
    this.model,
  );
}

class AttendanceSearchEventRemoveFromList extends AttendanceSearchEvent {
  final String modelId;
  AttendanceSearchEventRemoveFromList(
    this.modelId,
  );
}

class AttendanceSearchEventFormSubmitted extends AttendanceSearchEvent {
  final bool selectedProfessional;
  final UserProfileModel? professional;
  final bool selectedPatient;
  final PatientModel? patient;
  final bool selectedStartEnd;
  final DateTime? start;
  final DateTime? end;
  AttendanceSearchEventFormSubmitted({
    this.selectedProfessional = false,
    this.professional,
    this.selectedPatient = false,
    this.patient,
    this.selectedStartEnd = false,
    this.start,
    this.end,
  });
}
