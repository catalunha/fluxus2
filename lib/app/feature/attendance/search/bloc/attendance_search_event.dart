import '../../../../core/models/attendance_model.dart';

abstract class AttendanceSearchEvent {}

class AttendanceSearchEventNextPage extends AttendanceSearchEvent {}

class AttendanceSearchEventPreviousPage extends AttendanceSearchEvent {}

class AttendanceSearchEventUpdateList extends AttendanceSearchEvent {
  final AttendanceModel model;
  AttendanceSearchEventUpdateList(
    this.model,
  );
}

class AttendanceSearchEventRemoveFromList extends AttendanceSearchEvent {
  final String modelId;
  AttendanceSearchEventRemoveFromList(
    this.modelId,
  );
}

class AttendanceSearchEventFormSubmitted extends AttendanceSearchEvent {}
