import '../../../../core/models/attendance_model.dart';
import '../../../../core/models/event_model.dart';
import '../../../../core/models/room_model.dart';
import '../../../../core/models/status_model.dart';

abstract class ScheduleSearchEvent {}

class ScheduleSearchEventFormSubmitted extends ScheduleSearchEvent {
  final bool selectedStatus;
  final StatusModel? equalsStatus;
  final DateTime? start;
  final DateTime? end;
  ScheduleSearchEventFormSubmitted({
    required this.selectedStatus,
    this.equalsStatus,
    this.start,
    this.end,
  });
}

class ScheduleSearchEventFilterByRoom extends ScheduleSearchEvent {
  final RoomModel model;
  ScheduleSearchEventFilterByRoom(
    this.model,
  );
}

class ScheduleSearchEventUpdateAttendances extends ScheduleSearchEvent {
  final EventModel event;
  final List<AttendanceModel> attendances;
  ScheduleSearchEventUpdateAttendances(
    this.event,
    this.attendances,
  );
}

class ScheduleSearchEventUpdateList extends ScheduleSearchEvent {
  final EventModel model;
  ScheduleSearchEventUpdateList(
    this.model,
  );
}

class ScheduleSearchEventRemoveFromList extends ScheduleSearchEvent {
  final EventModel model;
  ScheduleSearchEventRemoveFromList(
    this.model,
  );
}
