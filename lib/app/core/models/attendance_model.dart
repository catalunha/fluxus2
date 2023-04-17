import 'dart:convert';

import 'package:fluxus2/app/core/models/patient_model.dart';
import 'package:fluxus2/app/core/models/procedure_model.dart';

import 'event_model.dart';
import 'evolution_model.dart';
import 'healthplan_model.dart';
import 'invoice_model.dart';
import 'status_model.dart';
import 'user_profile_model.dart';

class AttendanceModel {
  final String? id;
  final UserProfileModel? professional;
  final ProcedureModel? procedure;
  final PatientModel? patient;
  final HealthPlanModel? healthPlan;
  final String? authorizationCode;
  final DateTime? authorizationDateCreated;
  final DateTime? authorizationDateLimit;
  final DateTime? attendance;
  final String? description;
  final DateTime? confirmedPresence;
  final StatusModel? status;
  final EventModel? event;
  final EvolutionModel? evolution;
  final InvoiceModel? invoice;
  AttendanceModel({
    this.id,
    this.professional,
    this.procedure,
    this.patient,
    this.healthPlan,
    this.authorizationCode,
    this.authorizationDateCreated,
    this.authorizationDateLimit,
    this.attendance,
    this.description,
    this.confirmedPresence,
    this.status,
    this.event,
    this.evolution,
    this.invoice,
  });

  AttendanceModel copyWith({
    String? id,
    UserProfileModel? professional,
    ProcedureModel? procedure,
    PatientModel? patient,
    HealthPlanModel? healthPlan,
    String? authorizationCode,
    DateTime? authorizationDateCreated,
    DateTime? authorizationDateLimit,
    DateTime? attendance,
    String? description,
    DateTime? confirmedPresence,
    StatusModel? status,
    EventModel? event,
    EvolutionModel? evolution,
    InvoiceModel? invoice,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      professional: professional ?? this.professional,
      procedure: procedure ?? this.procedure,
      patient: patient ?? this.patient,
      healthPlan: healthPlan ?? this.healthPlan,
      authorizationCode: authorizationCode ?? this.authorizationCode,
      authorizationDateCreated:
          authorizationDateCreated ?? this.authorizationDateCreated,
      authorizationDateLimit:
          authorizationDateLimit ?? this.authorizationDateLimit,
      attendance: attendance ?? this.attendance,
      description: description ?? this.description,
      confirmedPresence: confirmedPresence ?? this.confirmedPresence,
      status: status ?? this.status,
      event: event ?? this.event,
      evolution: evolution ?? this.evolution,
      invoice: invoice ?? this.invoice,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (professional != null) {
      result.addAll({'professional': professional!.toMap()});
    }
    if (procedure != null) {
      result.addAll({'procedure': procedure!.toMap()});
    }
    if (patient != null) {
      result.addAll({'patient': patient!.toMap()});
    }
    if (healthPlan != null) {
      result.addAll({'healthPlan': healthPlan!.toMap()});
    }
    if (authorizationCode != null) {
      result.addAll({'authorizationCode': authorizationCode});
    }
    if (authorizationDateCreated != null) {
      result.addAll({
        'authorizationDateCreated':
            authorizationDateCreated!.millisecondsSinceEpoch
      });
    }
    if (authorizationDateLimit != null) {
      result.addAll({
        'authorizationDateLimit': authorizationDateLimit!.millisecondsSinceEpoch
      });
    }
    if (attendance != null) {
      result.addAll({'attendance': attendance!.millisecondsSinceEpoch});
    }
    if (description != null) {
      result.addAll({'description': description});
    }
    if (confirmedPresence != null) {
      result.addAll(
          {'confirmedPresence': confirmedPresence!.millisecondsSinceEpoch});
    }
    if (status != null) {
      result.addAll({'status': status!.toMap()});
    }
    if (event != null) {
      result.addAll({'event': event!.toMap()});
    }
    if (evolution != null) {
      result.addAll({'evolution': evolution!.toMap()});
    }
    if (invoice != null) {
      result.addAll({'invoice': invoice!.toMap()});
    }

    return result;
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'],
      professional: map['professional'] != null
          ? UserProfileModel.fromMap(map['professional'])
          : null,
      procedure: map['procedure'] != null
          ? ProcedureModel.fromMap(map['procedure'])
          : null,
      patient:
          map['patient'] != null ? PatientModel.fromMap(map['patient']) : null,
      healthPlan: map['healthPlan'] != null
          ? HealthPlanModel.fromMap(map['healthPlan'])
          : null,
      authorizationCode: map['authorizationCode'],
      authorizationDateCreated: map['authorizationDateCreated'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['authorizationDateCreated'])
          : null,
      authorizationDateLimit: map['authorizationDateLimit'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['authorizationDateLimit'])
          : null,
      attendance: map['attendance'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['attendance'])
          : null,
      description: map['description'],
      confirmedPresence: map['confirmedPresence'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['confirmedPresence'])
          : null,
      status: map['status'] != null ? StatusModel.fromMap(map['status']) : null,
      event: map['event'] != null ? EventModel.fromMap(map['event']) : null,
      evolution: map['evolution'] != null
          ? EvolutionModel.fromMap(map['evolution'])
          : null,
      invoice:
          map['invoice'] != null ? InvoiceModel.fromMap(map['invoice']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceModel.fromJson(String source) =>
      AttendanceModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AttendanceModel(id: $id, professional: $professional, procedure: $procedure, patient: $patient, healthPlan: $healthPlan, authorizationCode: $authorizationCode, authorizationDateCreated: $authorizationDateCreated, authorizationDateLimit: $authorizationDateLimit, attendance: $attendance, description: $description, confirmedPresence: $confirmedPresence, status: $status, event: $event, evolution: $evolution, invoice: $invoice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AttendanceModel &&
        other.id == id &&
        other.professional == professional &&
        other.procedure == procedure &&
        other.patient == patient &&
        other.healthPlan == healthPlan &&
        other.authorizationCode == authorizationCode &&
        other.authorizationDateCreated == authorizationDateCreated &&
        other.authorizationDateLimit == authorizationDateLimit &&
        other.attendance == attendance &&
        other.description == description &&
        other.confirmedPresence == confirmedPresence &&
        other.status == status &&
        other.event == event &&
        other.evolution == evolution &&
        other.invoice == invoice;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        professional.hashCode ^
        procedure.hashCode ^
        patient.hashCode ^
        healthPlan.hashCode ^
        authorizationCode.hashCode ^
        authorizationDateCreated.hashCode ^
        authorizationDateLimit.hashCode ^
        attendance.hashCode ^
        description.hashCode ^
        confirmedPresence.hashCode ^
        status.hashCode ^
        event.hashCode ^
        evolution.hashCode ^
        invoice.hashCode;
  }
}
