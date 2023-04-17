import '../../../../core/models/healthplan_model.dart';
import '../../../../core/models/patient_model.dart';
import '../../../../core/models/procedure_model.dart';
import '../../../../core/models/user_profile_model.dart';

abstract class AttendanceSaveEvent {}

class AttendanceSaveEventDelete extends AttendanceSaveEvent {}

class AttendanceSaveEventFormSubmitted extends AttendanceSaveEvent {
  final String? authorizationCode;
  final DateTime? authorizationDateCreated;
  final DateTime? authorizationDateLimit;
  final String? description;
  AttendanceSaveEventFormSubmitted({
    this.authorizationCode,
    this.authorizationDateCreated,
    this.authorizationDateLimit,
    this.description,
  });
}

class AttendanceSaveEventSetProfessional extends AttendanceSaveEvent {
  final UserProfileModel model;
  AttendanceSaveEventSetProfessional(this.model);
}

class AttendanceSaveEventDuplicateProcedure extends AttendanceSaveEvent {
  final ProcedureModel model;
  AttendanceSaveEventDuplicateProcedure(this.model);
}

class AttendanceSaveEventRemoveProcedure extends AttendanceSaveEvent {
  final ProcedureModel model;
  AttendanceSaveEventRemoveProcedure(this.model);
}

class AttendanceSaveEventSetPatient extends AttendanceSaveEvent {
  final PatientModel model;
  AttendanceSaveEventSetPatient(this.model);
}

class AttendanceSaveEventRemoveHealthPlan extends AttendanceSaveEvent {
  final HealthPlanModel model;
  AttendanceSaveEventRemoveHealthPlan(this.model);
}
