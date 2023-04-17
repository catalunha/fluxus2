import '../../../../core/models/attendance_model.dart';

abstract class AttendanceSelectEvent {}

class AttendanceSelectEventNextPage extends AttendanceSelectEvent {}

class AttendanceSelectEventPreviousPage extends AttendanceSelectEvent {}

class AttendanceSelectEventStartQuery extends AttendanceSelectEvent {}

class AttendanceSelectEventFormSubmitted extends AttendanceSelectEvent {
  final String authorizationCode;
  AttendanceSelectEventFormSubmitted(this.authorizationCode);
}

class AttendanceSelectEventUpdateSelectedValues extends AttendanceSelectEvent {
  final AttendanceModel model;
  AttendanceSelectEventUpdateSelectedValues(
    this.model,
  );
}
