import '../../../../core/models/expertise_model.dart';

enum ExpertiseSaveStateStatus { initial, loading, success, error }

class ExpertiseSaveState {
  final ExpertiseSaveStateStatus status;
  final String? error;
  final ExpertiseModel? model;
  ExpertiseSaveState({
    required this.status,
    this.error,
    this.model,
  });
  ExpertiseSaveState.initial(this.model)
      : status = ExpertiseSaveStateStatus.initial,
        error = '';
  ExpertiseSaveState copyWith({
    ExpertiseSaveStateStatus? status,
    String? error,
    ExpertiseModel? model,
  }) {
    return ExpertiseSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpertiseSaveState &&
        other.status == status &&
        other.error == error &&
        other.model == model;
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ model.hashCode;
  }
}
