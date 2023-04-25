import '../../../../core/models/attendance_model.dart';

enum AttendanceViewStateStatus { initial, updated, loading, success, error }

class AttendanceViewState {
  final AttendanceViewStateStatus status;
  final String? error;
  final AttendanceModel model;
  AttendanceViewState({
    required this.status,
    this.error,
    required this.model,
  });
  AttendanceViewState.initial(this.model)
      : status = AttendanceViewStateStatus.initial,
        error = '';
  AttendanceViewState copyWith({
    AttendanceViewStateStatus? status,
    String? error,
    AttendanceModel? model,
  }) {
    return AttendanceViewState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }

  @override
  String toString() =>
      'AttendanceViewState(status: $status, error: $error, model: $model)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AttendanceViewState &&
        other.status == status &&
        other.error == error &&
        other.model == model;
  }

  @override
  int get hashCode => status.hashCode ^ error.hashCode ^ model.hashCode;
}
