abstract class GraduationSaveEvent {}

class GraduationSaveEventDelete extends GraduationSaveEvent {}

class GraduationSaveEventFormSubmitted extends GraduationSaveEvent {
  final String? name;
  GraduationSaveEventFormSubmitted({
    this.name,
  });
}
