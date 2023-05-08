import 'package:flutter/foundation.dart';

import '../../../../core/models/healthplan_model.dart';
import '../../../../core/models/patient_model.dart';
import '../../../../core/models/region_model.dart';

enum PatientSaveStateStatus {
  initial,
  fetched,
  updated,
  loading,
  success,
  error
}

class PatientSaveState {
  final PatientSaveStateStatus status;
  final String? error;
  final PatientModel? model;
  final RegionModel? region;
  final List<PatientModel> familyOriginal;
  final List<PatientModel> familyUpdated;
  final List<HealthPlanModel> healthPlansOriginal;
  final List<HealthPlanModel> healthPlansUpdated;
  PatientSaveState({
    required this.status,
    this.error,
    required this.model,
    this.region,
    this.familyOriginal = const [],
    this.familyUpdated = const [],
    this.healthPlansOriginal = const [],
    this.healthPlansUpdated = const [],
  });

  PatientSaveState.initial(this.model)
      : status = PatientSaveStateStatus.initial,
        error = '',
        familyOriginal = model?.family ?? [],
        familyUpdated = model?.family ?? [],
        healthPlansOriginal = model?.healthPlans ?? [],
        healthPlansUpdated = model?.healthPlans ?? [],
        region = model?.region;

  PatientSaveState copyWith({
    PatientSaveStateStatus? status,
    String? error,
    PatientModel? model,
    RegionModel? region,
    List<PatientModel>? familyOriginal,
    List<PatientModel>? familyUpdated,
    List<HealthPlanModel>? healthPlansOriginal,
    List<HealthPlanModel>? healthPlansUpdated,
  }) {
    return PatientSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
      region: region ?? this.region,
      familyOriginal: familyOriginal ?? this.familyOriginal,
      familyUpdated: familyUpdated ?? this.familyUpdated,
      healthPlansOriginal: healthPlansOriginal ?? this.healthPlansOriginal,
      healthPlansUpdated: healthPlansUpdated ?? this.healthPlansUpdated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PatientSaveState &&
        other.status == status &&
        other.error == error &&
        other.model == model &&
        other.region == region &&
        listEquals(other.familyOriginal, familyOriginal) &&
        listEquals(other.familyUpdated, familyUpdated) &&
        listEquals(other.healthPlansOriginal, healthPlansOriginal) &&
        listEquals(other.healthPlansUpdated, healthPlansUpdated);
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        model.hashCode ^
        region.hashCode ^
        familyOriginal.hashCode ^
        familyUpdated.hashCode ^
        healthPlansOriginal.hashCode ^
        healthPlansUpdated.hashCode;
  }

  @override
  String toString() {
    return 'PatientSaveState(status: $status, error: $error, model: $model, region: $region, familyOriginal: $familyOriginal, familyUpdated: $familyUpdated, healthPlansOriginal: $healthPlansOriginal, healthPlansUpdated: $healthPlansUpdated)';
  }
}
