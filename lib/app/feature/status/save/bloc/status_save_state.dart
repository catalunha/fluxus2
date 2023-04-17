import '../../../../core/models/Status_model.dart';

enum StatusSaveStateStatus { initial, loading, success, error }

class StatusSaveState {
  final StatusSaveStateStatus status;
  final String? error;
  final StatusModel? model;
  StatusSaveState({
    required this.status,
    this.error,
    this.model,
  });
  StatusSaveState.initial(this.model)
      : status = StatusSaveStateStatus.initial,
        error = '';
  StatusSaveState copyWith({
    StatusSaveStateStatus? status,
    String? error,
    StatusModel? model,
  }) {
    return StatusSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StatusSaveState &&
        other.status == status &&
        other.error == error &&
        other.model == model;
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ model.hashCode;
  }
}
