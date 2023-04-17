abstract class OfficeSaveEvent {}

class OfficeSaveEventDelete extends OfficeSaveEvent {}

class OfficeSaveEventFormSubmitted extends OfficeSaveEvent {
  final String? name;
  OfficeSaveEventFormSubmitted({
    this.name,
  });
}
