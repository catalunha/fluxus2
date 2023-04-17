abstract class StatusSaveEvent {}

class StatusSaveEventDelete extends StatusSaveEvent {}

class StatusSaveEventFormSubmitted extends StatusSaveEvent {
  final String? name;
  StatusSaveEventFormSubmitted({
    this.name,
  });
}
