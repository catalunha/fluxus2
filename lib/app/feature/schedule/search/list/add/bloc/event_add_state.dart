
import 'package:flutter/foundation.dart';

import '../../../../../../core/models/attendance_model.dart';
import '../../../../../../core/models/event_model.dart';
import '../../../../../../core/models/room_model.dart';
import '../../../../../../core/models/status_model.dart';

enum EventAddStateStatus { initial, updated, loading, success, error }

class EventAddState {
  final EventAddStateStatus status;
  final String? error;
  final EventModel? model;
  final RoomModel? room;
  final StatusModel? statusEvent;
  final List<AttendanceModel> attendancesOriginal;
  final List<AttendanceModel> attendancesUpdated;
  EventAddState({
    required this.status,
    this.error,
    required this.model,
    this.room,
    this.statusEvent,
    this.attendancesOriginal = const [],
    this.attendancesUpdated = const [],
  });

  EventAddState.initial(this.model)
      : status = EventAddStateStatus.initial,
        error = '',
        attendancesOriginal = model?.attendances ?? [],
        attendancesUpdated = model?.attendances ?? [],
        room = model?.room,
        statusEvent = model?.status;

  EventAddState copyWith({
    EventAddStateStatus? status,
    String? error,
    EventModel? model,
    RoomModel? room,
    StatusModel? statusEvent,
    List<AttendanceModel>? attendancesOriginal,
    List<AttendanceModel>? attendancesUpdated,
  }) {
    return EventAddState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
      room: room ?? this.room,
      statusEvent: statusEvent ?? this.statusEvent,
      attendancesOriginal: attendancesOriginal ?? this.attendancesOriginal,
      attendancesUpdated: attendancesUpdated ?? this.attendancesUpdated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventAddState &&
        other.status == status &&
        other.error == error &&
        other.model == model &&
        other.room == room &&
        other.statusEvent == statusEvent &&
        listEquals(other.attendancesOriginal, attendancesOriginal) &&
        listEquals(other.attendancesUpdated, attendancesUpdated);
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        model.hashCode ^
        room.hashCode ^
        statusEvent.hashCode ^
        attendancesOriginal.hashCode ^
        attendancesUpdated.hashCode;
  }

  @override
  String toString() {
    return 'EventAddState(status: $status, error: $error, model: $model, room: $room, statusEvent: $statusEvent, attendancesOriginal: $attendancesOriginal, attendancesUpdated: $attendancesUpdated)';
  }
}
