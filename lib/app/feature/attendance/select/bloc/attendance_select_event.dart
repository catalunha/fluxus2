abstract class AttendanceSelectEvent {}

class AttendanceSelectEventNextPage extends AttendanceSelectEvent {}

class AttendanceSelectEventPreviousPage extends AttendanceSelectEvent {}

class AttendanceSelectEventStartQuery extends AttendanceSelectEvent {}

class AttendanceSelectEventFormSubmitted extends AttendanceSelectEvent {
  final String name;
  AttendanceSelectEventFormSubmitted(this.name);
}
