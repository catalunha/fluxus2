import '../../../../core/models/attendance_model.dart';
import '../../../../core/models/room_model.dart';
import '../../../../core/models/status_model.dart';

abstract class EventSaveEvent {}

class EventSaveEventStart extends EventSaveEvent {}

class EventSaveEventFormSubmitted extends EventSaveEvent {
  final String? history;
  final DateTime? start;
  final DateTime? end;
  EventSaveEventFormSubmitted({
    this.history,
    this.start,
    this.end,
  });
}

class EventSaveEventAddRoom extends EventSaveEvent {
  final RoomModel model;
  EventSaveEventAddRoom(this.model);
}

class EventSaveEventAddStatus extends EventSaveEvent {
  final StatusModel model;
  EventSaveEventAddStatus(this.model);
}

class EventSaveEventAddAttendance extends EventSaveEvent {
  final AttendanceModel model;
  EventSaveEventAddAttendance(
    this.model,
  );
}

class EventSaveEventRemoveAttendance extends EventSaveEvent {
  final AttendanceModel model;
  EventSaveEventRemoveAttendance(
    this.model,
  );
}
