abstract class AttendanceSaveEvent {}

class AttendanceSaveEventDelete extends AttendanceSaveEvent {}

class AttendanceSaveEventFormSubmitted extends AttendanceSaveEvent {
  final String? uf;
  final String? city;
  final String? name;
  AttendanceSaveEventFormSubmitted({
    this.uf,
    this.city,
    this.name,
  });
}
