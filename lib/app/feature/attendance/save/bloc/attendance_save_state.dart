import '../../../../core/models/Attendance_model.dart';

enum AttendanceSaveStateStatus { initial, loading, success, error }

class AttendanceSaveState {
  final AttendanceSaveStateStatus status;
  final String? error;
  final AttendanceModel? model;
  AttendanceSaveState({
    required this.status,
    this.error,
    this.model,
  });
  AttendanceSaveState.initial(this.model)
      : status = AttendanceSaveStateStatus.initial,
        error = '';
  AttendanceSaveState copyWith({
    AttendanceSaveStateStatus? status,
    String? error,
    AttendanceModel? model,
  }) {
    return AttendanceSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AttendanceSaveState &&
        other.status == status &&
        other.error == error &&
        other.model == model;
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ model.hashCode;
  }
}
