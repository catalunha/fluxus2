import '../../../../core/models/Attendance_model.dart';

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

class AttendanceSearchEventFormSubmitted extends AttendanceSearchEvent {
  final bool ufContainsBool;
  final String ufContainsString;
  final bool cityContainsBool;
  final String cityContainsString;
  final bool nameContainsBool;
  final String nameContainsString;
  AttendanceSearchEventFormSubmitted({
    required this.ufContainsBool,
    required this.ufContainsString,
    required this.cityContainsBool,
    required this.cityContainsString,
    required this.nameContainsBool,
    required this.nameContainsString,
  });
}
