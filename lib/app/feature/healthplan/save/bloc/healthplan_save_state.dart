import '../../../../core/models/healthplan_model.dart';
import '../../../../core/models/healthplantype_model.dart';

enum HealthPlanSaveStateStatus { initial, loading, success, error }

class HealthPlanSaveState {
  final HealthPlanSaveStateStatus status;
  final String? error;
  final HealthPlanModel? model;
  final HealthPlanTypeModel? healthPlanType;

  HealthPlanSaveState({
    required this.status,
    this.error,
    this.model,
    this.healthPlanType,
  });
  HealthPlanSaveState.initial(this.model)
      : status = HealthPlanSaveStateStatus.initial,
        error = '',
        healthPlanType = model?.healthPlanType;
  HealthPlanSaveState copyWith({
    HealthPlanSaveStateStatus? status,
    String? error,
    HealthPlanModel? model,
    HealthPlanTypeModel? healthPlanType,
  }) {
    return HealthPlanSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
      healthPlanType: healthPlanType ?? this.healthPlanType,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HealthPlanSaveState &&
        other.status == status &&
        other.error == error &&
        other.model == model &&
        other.healthPlanType == healthPlanType;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        model.hashCode ^
        healthPlanType.hashCode;
  }

  @override
  String toString() {
    return 'HealthPlanSaveState(status: $status, error: $error, model: $model, healthPlanType: $healthPlanType)';
  }
}
