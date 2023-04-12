import '../../../../core/models/region_model.dart';

abstract class RegionSearchEvent {}

class RegionSearchEventNextPage extends RegionSearchEvent {}

class RegionSearchEventPreviousPage extends RegionSearchEvent {}

class RegionSearchEventUpdateList extends RegionSearchEvent {
  final RegionModel model;
  RegionSearchEventUpdateList(
    this.model,
  );
}

class RegionSearchEventRemoveFromList extends RegionSearchEvent {
  final String modelId;
  RegionSearchEventRemoveFromList(
    this.modelId,
  );
}

class RegionSearchEventFormSubmitted extends RegionSearchEvent {
  final bool ufContainsBool;
  final String ufContainsString;
  final bool cityContainsBool;
  final String cityContainsString;
  final bool nameContainsBool;
  final String nameContainsString;
  RegionSearchEventFormSubmitted({
    required this.ufContainsBool,
    required this.ufContainsString,
    required this.cityContainsBool,
    required this.cityContainsString,
    required this.nameContainsBool,
    required this.nameContainsString,
  });
}
