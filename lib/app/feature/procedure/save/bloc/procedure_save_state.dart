import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/procedure_model.dart';

enum ProcedureSaveStateStatus { initial, loading, success, error }

class ProcedureSaveState {
  final ProcedureSaveStateStatus status;
  final String? error;
  final ProcedureModel? model;
  final ExpertiseModel? expertise;

  ProcedureSaveState({
    required this.status,
    this.error,
    this.model,
    this.expertise,
  });
  ProcedureSaveState.initial(this.model)
      : status = ProcedureSaveStateStatus.initial,
        error = '',
        expertise = model?.expertise;
  ProcedureSaveState copyWith({
    ProcedureSaveStateStatus? status,
    String? error,
    ProcedureModel? model,
    ExpertiseModel? expertise,
  }) {
    return ProcedureSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
      expertise: expertise ?? this.expertise,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProcedureSaveState &&
        other.status == status &&
        other.error == error &&
        other.model == model &&
        other.expertise == expertise;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        model.hashCode ^
        expertise.hashCode;
  }

  @override
  String toString() {
    return 'ProcedureSaveState(status: $status, error: $error, model: $model, expertise: $expertise)';
  }
}
