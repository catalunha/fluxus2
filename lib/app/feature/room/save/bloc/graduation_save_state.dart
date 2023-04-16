import '../../../../core/models/graduation_model.dart';

enum GraduationSaveStateStatus { initial, loading, success, error }

class GraduationSaveState {
  final GraduationSaveStateStatus status;
  final String? error;
  final GraduationModel? model;
  GraduationSaveState({
    required this.status,
    this.error,
    this.model,
  });
  GraduationSaveState.initial(this.model)
      : status = GraduationSaveStateStatus.initial,
        error = '';
  GraduationSaveState copyWith({
    GraduationSaveStateStatus? status,
    String? error,
    GraduationModel? model,
  }) {
    return GraduationSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GraduationSaveState &&
        other.status == status &&
        other.error == error &&
        other.model == model;
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ model.hashCode;
  }
}
