import '../../../../core/models/graduation_model.dart';

abstract class GraduationSelectEvent {}

class GraduationSelectEventNextPage extends GraduationSelectEvent {}

class GraduationSelectEventPreviousPage extends GraduationSelectEvent {}

class GraduationSelectEventStartQuery extends GraduationSelectEvent {}

class GraduationSelectEventFormSubmitted extends GraduationSelectEvent {
  final String name;
  GraduationSelectEventFormSubmitted(this.name);
}

class GraduationSelectEventUpdateSelectedValues extends GraduationSelectEvent {
  final GraduationModel model;
  GraduationSelectEventUpdateSelectedValues(
    this.model,
  );
}

// class GraduationSelectEventRemoveSelected extends GraduationSelectEvent {
//   final GraduationModel model;
//   GraduationSelectEventRemoveSelected({
//     required this.model,
//   });
// }
