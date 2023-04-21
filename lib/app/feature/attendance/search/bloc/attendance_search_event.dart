import '../../../../core/models/attendance_model.dart';
import '../../../../core/models/patient_model.dart';
import '../../../../core/models/procedure_model.dart';
import '../../../../core/models/status_model.dart';
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
  final UserProfileModel? equalsProfessional;
  final bool selectedProcedure;
  final ProcedureModel? equalsProcedure;
  final bool selectedPatient;
  final PatientModel? equalsPatient;
  final bool selectedStatus;
  final StatusModel? equalsStatus;
  final DateTime? start;
  final DateTime? end;
  AttendanceSearchEventFormSubmitted({
    this.selectedProfessional = false,
    this.equalsProfessional,
    this.selectedProcedure = false,
    this.equalsProcedure,
    this.selectedPatient = false,
    this.equalsPatient,
    this.selectedStatus = false,
    this.equalsStatus,
    this.start,
    this.end,
  });
}
