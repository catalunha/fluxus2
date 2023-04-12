import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/graduation_model.dart';
import '../../../../core/models/procedure_model.dart';

abstract class UserProfileAccessEvent {}

class UserProfileAccessEventFormSubmitted extends UserProfileAccessEvent {
  final bool isActive;
  UserProfileAccessEventFormSubmitted({
    required this.isActive,
  });
}

class UserProfileAccessEventUpdateAccess extends UserProfileAccessEvent {
  final String access;
  UserProfileAccessEventUpdateAccess({
    required this.access,
  });
}

class UserProfileAccessEventAddGraduation extends UserProfileAccessEvent {
  final GraduationModel model;
  UserProfileAccessEventAddGraduation(
    this.model,
  );
}

class UserProfileAccessEventRemoveGraduation extends UserProfileAccessEvent {
  final GraduationModel model;
  UserProfileAccessEventRemoveGraduation(
    this.model,
  );
}

class UserProfileAccessEventAddExpertise extends UserProfileAccessEvent {
  final ExpertiseModel model;
  UserProfileAccessEventAddExpertise(
    this.model,
  );
}

class UserProfileAccessEventRemoveExpertise extends UserProfileAccessEvent {
  final ExpertiseModel model;
  UserProfileAccessEventRemoveExpertise(
    this.model,
  );
}

class UserProfileAccessEventAddProcedure extends UserProfileAccessEvent {
  final ProcedureModel model;
  UserProfileAccessEventAddProcedure(
    this.model,
  );
}

class UserProfileAccessEventRemoveProcedure extends UserProfileAccessEvent {
  final ProcedureModel model;
  UserProfileAccessEventRemoveProcedure(
    this.model,
  );
}
