abstract class ExpertiseSaveEvent {}

class ExpertiseSaveEventDelete extends ExpertiseSaveEvent {}

class ExpertiseSaveEventFormSubmitted extends ExpertiseSaveEvent {
  final String? name;
  ExpertiseSaveEventFormSubmitted({
    this.name,
  });
}
