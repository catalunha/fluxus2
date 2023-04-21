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
