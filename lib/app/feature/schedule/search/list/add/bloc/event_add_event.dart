
import '../../../../../../core/models/attendance_model.dart';
import '../../../../../../core/models/room_model.dart';
import '../../../../../../core/models/status_model.dart';

abstract class EventAddEvent {}

class EventAddEventStart extends EventAddEvent {}

class EventAddEventFormSubmitted extends EventAddEvent {
  final String? history;
  final DateTime? start;
  final DateTime? end;
  EventAddEventFormSubmitted({
    this.history,
    this.start,
    this.end,
  });
}

class EventAddEventAddRoom extends EventAddEvent {
  final RoomModel model;
  EventAddEventAddRoom(this.model);
}

class EventAddEventAddStatus extends EventAddEvent {
  final StatusModel model;
  EventAddEventAddStatus(this.model);
}

class EventAddEventAddAttendance extends EventAddEvent {
  final AttendanceModel model;
  EventAddEventAddAttendance(
    this.model,
  );
}

class EventAddEventRemoveAttendance extends EventAddEvent {
  final AttendanceModel model;
  EventAddEventRemoveAttendance(
    this.model,
  );
}
