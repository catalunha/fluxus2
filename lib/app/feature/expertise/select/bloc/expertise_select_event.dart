abstract class ExpertiseSelectEvent {}

class ExpertiseSelectEventNextPage extends ExpertiseSelectEvent {}

class ExpertiseSelectEventPreviousPage extends ExpertiseSelectEvent {}

class ExpertiseSelectEventStartQuery extends ExpertiseSelectEvent {}

class ExpertiseSelectEventFormSubmitted extends ExpertiseSelectEvent {
  final String name;
  ExpertiseSelectEventFormSubmitted(this.name);
}
