abstract class StatusSaveEvent {}

class StatusSaveEventDelete extends StatusSaveEvent {}

class StatusSaveEventFormSubmitted extends StatusSaveEvent {
  final String? name;
  final String? description;
  StatusSaveEventFormSubmitted({
    this.name,
    this.description,
  });
}
