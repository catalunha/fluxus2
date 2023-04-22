import 'package:flutter/foundation.dart';

import '../../../../../../core/models/attendance_model.dart';
import '../../../../../../core/models/event_model.dart';

enum ScheduleConfirmPresenceStateStatus {
  initial,
  updated,
  loading,
  success,
  error
}

class ScheduleConfirmPresenceState {
  final ScheduleConfirmPresenceStateStatus status;
  final String? error;
  final EventModel event;
  final List<AttendanceModel> modelsAlreadyConfirmed;
  final List<AttendanceModel> modelsUnconfirmed;
  final List<AttendanceModel> modelsConfirmThese;
  ScheduleConfirmPresenceState({
    required this.status,
    this.error,
    required this.event,
    this.modelsAlreadyConfirmed = const [],
    this.modelsUnconfirmed = const [],
    this.modelsConfirmThese = const [],
  });

  ScheduleConfirmPresenceState.initial(this.event)
      : status = ScheduleConfirmPresenceStateStatus.initial,
        error = '',
        modelsAlreadyConfirmed = [],
        modelsConfirmThese = [],
        modelsUnconfirmed = [];

  ScheduleConfirmPresenceState copyWith({
    ScheduleConfirmPresenceStateStatus? status,
    String? error,
    EventModel? event,
    List<AttendanceModel>? modelsAlreadyConfirmed,
    List<AttendanceModel>? modelsUnconfirmed,
    List<AttendanceModel>? modelsConfirmThese,
  }) {
    return ScheduleConfirmPresenceState(
      status: status ?? this.status,
      error: error ?? this.error,
      event: event ?? this.event,
      modelsAlreadyConfirmed:
          modelsAlreadyConfirmed ?? this.modelsAlreadyConfirmed,
      modelsUnconfirmed: modelsUnconfirmed ?? this.modelsUnconfirmed,
      modelsConfirmThese: modelsConfirmThese ?? this.modelsConfirmThese,
    );
  }

  @override
  String toString() {
    return 'ScheduleConfirmPresenceState(status: $status, error: $error, event: $event, modelsAlreadyConfirmed: $modelsAlreadyConfirmed, modelsUnconfirmed: $modelsUnconfirmed, modelsConfirmThese: $modelsConfirmThese)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScheduleConfirmPresenceState &&
        other.status == status &&
        other.error == error &&
        other.event == event &&
        listEquals(other.modelsAlreadyConfirmed, modelsAlreadyConfirmed) &&
        listEquals(other.modelsUnconfirmed, modelsUnconfirmed) &&
        listEquals(other.modelsConfirmThese, modelsConfirmThese);
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        event.hashCode ^
        modelsAlreadyConfirmed.hashCode ^
        modelsUnconfirmed.hashCode ^
        modelsConfirmThese.hashCode;
  }
}
