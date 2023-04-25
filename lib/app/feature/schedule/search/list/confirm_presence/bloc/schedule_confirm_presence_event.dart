import '../../../../../../core/models/attendance_model.dart';

abstract class ScheduleConfirmPresenceEvent {}

class ScheduleConfirmPresenceEventStart extends ScheduleConfirmPresenceEvent {}

class ScheduleConfirmPresenceEventAddConfirm
    extends ScheduleConfirmPresenceEvent {
  final AttendanceModel model;
  ScheduleConfirmPresenceEventAddConfirm(this.model);
}

class ScheduleConfirmPresenceEventRemoveConfirm
    extends ScheduleConfirmPresenceEvent {
  final AttendanceModel model;
  ScheduleConfirmPresenceEventRemoveConfirm(this.model);
}

class ScheduleConfirmPresenceEventUpdate extends ScheduleConfirmPresenceEvent {}
