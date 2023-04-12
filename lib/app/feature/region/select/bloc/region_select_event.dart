abstract class RegionSelectEvent {}

class RegionSelectEventNextPage extends RegionSelectEvent {}

class RegionSelectEventPreviousPage extends RegionSelectEvent {}

class RegionSelectEventStartQuery extends RegionSelectEvent {}

class RegionSelectEventFormSubmitted extends RegionSelectEvent {
  final String name;
  RegionSelectEventFormSubmitted(this.name);
}
