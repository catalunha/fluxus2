import '../../../../core/models/event_model.dart';
import '../../../../core/models/patient_model.dart';
import '../../../../core/models/procedure_model.dart';
import '../../../../core/models/room_model.dart';
import '../../../../core/models/status_model.dart';
import '../../../../core/models/user_profile_model.dart';

abstract class EventSearchEvent {}

class EventSearchEventNextPage extends EventSearchEvent {}

class EventSearchEventPreviousPage extends EventSearchEvent {}

class EventSearchEventUpdateList extends EventSearchEvent {
  final EventModel model;
  EventSearchEventUpdateList(
    this.model,
  );
}

class EventSearchEventRemoveFromList extends EventSearchEvent {
  final EventModel model;
  EventSearchEventRemoveFromList(
    this.model,
  );
}

class EventSearchEventFormSubmitted extends EventSearchEvent {
  final bool selectedProfessional;
  final UserProfileModel? equalsProfessional;
  final bool selectedProcedure;
  final ProcedureModel? equalsProcedure;
  final bool selectedPatient;
  final PatientModel? equalsPatient;
  final bool selectedStatus;
  final StatusModel? equalsStatus;
  final bool selectedRoom;
  final RoomModel? equalsRoom;
  final DateTime? start;
  final DateTime? end;
  EventSearchEventFormSubmitted({
    this.selectedProfessional = false,
    this.equalsProfessional,
    this.selectedProcedure = false,
    this.equalsProcedure,
    this.selectedPatient = false,
    this.equalsPatient,
    this.selectedStatus = false,
    this.equalsStatus,
    this.selectedRoom = false,
    this.equalsRoom,
    this.start,
    this.end,
  });
}
