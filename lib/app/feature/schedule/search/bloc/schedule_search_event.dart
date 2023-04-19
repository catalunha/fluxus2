import '../../../../core/models/room_model.dart';
import '../../../../core/models/status_model.dart';

abstract class ScheduleSearchEvent {}

class ScheduleSearchEventFormSubmitted extends ScheduleSearchEvent {
  // final bool selectedRoom;
  // final RoomModel? equalsRoom;
  final bool selectedStatus;
  final StatusModel? equalsStatus;
  final bool selectedStartEnd;
  final DateTime? start;
  final DateTime? end;
  ScheduleSearchEventFormSubmitted({
    // required this.selectedRoom,
    // this.equalsRoom,
    required this.selectedStatus,
    this.equalsStatus,
    required this.selectedStartEnd,
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
