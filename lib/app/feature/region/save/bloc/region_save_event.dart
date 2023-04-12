abstract class RegionSaveEvent {}

class RegionSaveEventDelete extends RegionSaveEvent {}

class RegionSaveEventFormSubmitted extends RegionSaveEvent {
  final String? uf;
  final String? city;
  final String? name;
  RegionSaveEventFormSubmitted({
    this.uf,
    this.city,
    this.name,
  });
}
