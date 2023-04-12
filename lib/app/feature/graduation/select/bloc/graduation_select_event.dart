abstract class GraduationSelectEvent {}

class GraduationSelectEventNextPage extends GraduationSelectEvent {}

class GraduationSelectEventPreviousPage extends GraduationSelectEvent {}

class GraduationSelectEventStartQuery extends GraduationSelectEvent {}

class GraduationSelectEventFormSubmitted extends GraduationSelectEvent {
  final String name;
  GraduationSelectEventFormSubmitted(this.name);
}
