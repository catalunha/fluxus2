import 'package:flutter/foundation.dart';

import '../../../../core/models/attendance_model.dart';
import '../../../../core/models/healthplan_model.dart';
import '../../../../core/models/patient_model.dart';
import '../../../../core/models/procedure_model.dart';
import '../../../../core/models/user_profile_model.dart';

enum AttendanceSaveStateStatus { initial, updated, loading, success, error }

class AttendanceSaveState {
  final AttendanceSaveStateStatus status;
  final String? error;
  final AttendanceModel? model;
  final UserProfileModel? professional;
  final List<ProcedureModel> procedures;
  final PatientModel? patient;
  final List<HealthPlanModel> healthPlans;

  AttendanceSaveState({
    required this.status,
    this.error,
    this.model,
    this.professional,
    required this.procedures,
    this.patient,
    required this.healthPlans,
  });
  AttendanceSaveState.initial(this.model)
      : status = AttendanceSaveStateStatus.initial,
        error = '',
        professional = model?.professional,
        procedures = model?.procedure != null ? [model!.procedure!] : [],
        patient = model?.patient,
        healthPlans = model?.healthPlan != null ? [model!.healthPlan!] : [];
  AttendanceSaveState copyWith({
    AttendanceSaveStateStatus? status,
    String? error,
    AttendanceModel? model,
    UserProfileModel? professional,
    List<ProcedureModel>? procedures,
    PatientModel? patient,
    List<HealthPlanModel>? healthPlans,
  }) {
    return AttendanceSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
      professional: professional ?? this.professional,
      procedures: procedures ?? this.procedures,
      patient: patient ?? this.patient,
      healthPlans: healthPlans ?? this.healthPlans,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AttendanceSaveState &&
        other.status == status &&
        other.error == error &&
        other.model == model &&
        other.professional == professional &&
        listEquals(other.procedures, procedures) &&
        other.patient == patient &&
        listEquals(other.healthPlans, healthPlans);
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        model.hashCode ^
        professional.hashCode ^
        procedures.hashCode ^
        patient.hashCode ^
        healthPlans.hashCode;
  }

  @override
  String toString() {
    return 'AttendanceSaveState(status: $status, error: $error, model: $model, professional: $professional, procedures: $procedures, patient: $patient, healthPlans: $healthPlans)';
  }
}
