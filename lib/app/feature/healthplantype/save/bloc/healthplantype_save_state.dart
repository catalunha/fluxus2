import '../../../../core/models/healthplantype_model.dart';

enum HealthPlanTypeSaveStateStatus { initial, loading, success, error }

class HealthPlanTypeSaveState {
  final HealthPlanTypeSaveStateStatus status;
  final String? error;
  final HealthPlanTypeModel? model;
  HealthPlanTypeSaveState({
    required this.status,
    this.error,
    this.model,
  });
  HealthPlanTypeSaveState.initial(this.model)
      : status = HealthPlanTypeSaveStateStatus.initial,
        error = '';
  HealthPlanTypeSaveState copyWith({
    HealthPlanTypeSaveStateStatus? status,
    String? error,
    HealthPlanTypeModel? model,
  }) {
    return HealthPlanTypeSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HealthPlanTypeSaveState &&
        other.status == status &&
        other.error == error &&
        other.model == model;
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ model.hashCode;
  }
}
