import '../../../../core/models/patient_model.dart';

enum PatientViewStateStatus { initial, updated, loading, success, error }

class PatientViewState {
  final PatientViewStateStatus status;
  final String? error;
  final PatientModel model;
  PatientViewState({
    required this.status,
    this.error,
    required this.model,
  });
  PatientViewState.initial(this.model)
      : status = PatientViewStateStatus.initial,
        error = '';

  PatientViewState copyWith({
    PatientViewStateStatus? status,
    String? error,
    PatientModel? model,
  }) {
    return PatientViewState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }

  @override
  String toString() =>
      'PatientViewState(status: $status, error: $error, model: $model)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PatientViewState &&
        other.status == status &&
        other.error == error &&
        other.model == model;
  }

  @override
  int get hashCode => status.hashCode ^ error.hashCode ^ model.hashCode;
}
