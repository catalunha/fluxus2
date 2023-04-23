import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/office_model.dart';
import '../../../../core/models/procedure_model.dart';

abstract class UserProfileAccessEvent {}

class UserProfileAccessEventStart extends UserProfileAccessEvent {}

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

class UserProfileAccessEventAddOffice extends UserProfileAccessEvent {
  final OfficeModel model;
  UserProfileAccessEventAddOffice(
    this.model,
  );
}

class UserProfileAccessEventRemoveOffice extends UserProfileAccessEvent {
  final OfficeModel model;
  UserProfileAccessEventRemoveOffice(
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
