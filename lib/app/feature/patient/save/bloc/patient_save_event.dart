import '../../../../core/models/healthplan_model.dart';
import '../../../../core/models/patient_model.dart';
import '../../../../core/models/region_model.dart';

abstract class PatientSaveEvent {}

class PatientSaveEventFormSubmitted extends PatientSaveEvent {
  final String? name;
  final String? nickname;
  final String? cpf;
  final String? phone;
  final String? address;
  final bool? isFemale;
  final DateTime? birthday;
  PatientSaveEventFormSubmitted({
    this.name,
    this.nickname,
    this.cpf,
    this.phone,
    this.address,
    this.isFemale,
    this.birthday,
  });
}

class PatientSaveEventAddRegion extends PatientSaveEvent {
  final RegionModel model;
  PatientSaveEventAddRegion(this.model);
}

class PatientSaveEventAddFamily extends PatientSaveEvent {
  final PatientModel model;
  PatientSaveEventAddFamily(
    this.model,
  );
}

class PatientSaveEventRemoveFamily extends PatientSaveEvent {
  final PatientModel model;
  PatientSaveEventRemoveFamily(
    this.model,
  );
}

class PatientSaveEventAddHealthPlan extends PatientSaveEvent {
  final HealthPlanModel model;
  PatientSaveEventAddHealthPlan(
    this.model,
  );
}

class PatientSaveEventUpdateHealthPlan extends PatientSaveEvent {
  final HealthPlanModel model;
  PatientSaveEventUpdateHealthPlan(
    this.model,
  );
}

class PatientSaveEventRemoveHealthPlan extends PatientSaveEvent {
  final HealthPlanModel model;
  PatientSaveEventRemoveHealthPlan(
    this.model,
  );
}
