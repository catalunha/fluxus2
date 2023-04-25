import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/attendance_model.dart';
import 'healthplan_entity.dart';
import 'patient_entity.dart';
import 'procedure_entity.dart';
import 'status_entity.dart';
import 'user_profile_entity.dart';

class AttendanceEntity {
  static const String className = 'Attendance';
  static const String id = 'objectId';
  //singleCols
  static const String authorizationCode = 'authorizationCode';
  static const String authorizationDateCreated = 'authorizationDateCreated';
  static const String authorizationDateLimit = 'authorizationDateLimit';
  static const String attendance = 'attendance';
  static const String confirmedPresence = 'confirmedPresence';
  static const String description = 'description';
  //pointerCols
  static const String professional = 'professional';
  static const String procedure = 'procedure';
  static const String patient = 'patient';
  static const String healthPlan = 'healthPlan';
  static const String status = 'status';

  static List<String> selectedCols(List<String> cols) {
    return cols.map((e) => '${AttendanceEntity.className}.$e').toList();
  }

  static final List<String> singleCols = [
    AttendanceEntity.authorizationCode,
    AttendanceEntity.authorizationDateCreated,
    AttendanceEntity.authorizationDateLimit,
    AttendanceEntity.attendance,
    AttendanceEntity.confirmedPresence,
    AttendanceEntity.description,
    AttendanceEntity.professional,
    AttendanceEntity.procedure,
    AttendanceEntity.patient,
    AttendanceEntity.healthPlan,
    AttendanceEntity.status,
  ].map((e) => '${AttendanceEntity.className}.$e').toList();

  static final List<String> pointerCols = [
    AttendanceEntity.professional,
    AttendanceEntity.procedure,
    AttendanceEntity.patient,
    AttendanceEntity.healthPlan,
    'healthPlan.healthPlanType',
    AttendanceEntity.status,
  ].map((e) => '${AttendanceEntity.className}.$e').toList();

  static final List<String> relationCols =
      [].map((e) => '${AttendanceEntity.className}.$e').toList();

  // static final List<String> allCols = [
  //   ...AttendanceEntity.singleCols,
  //   ...AttendanceEntity.pointerCols,
  //   ...AttendanceEntity.relationCols
  // ];

  static List<String> filterSingleCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (AttendanceEntity.singleCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${AttendanceEntity.className}.', ''))
        .toList();
  }

  static List<String> filterPointerCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (AttendanceEntity.pointerCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${AttendanceEntity.className}.', ''))
        .toList();
  }

  static List<String> filterRelationCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (AttendanceEntity.relationCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${AttendanceEntity.className}.', ''))
        .toList();
  }

  Future<AttendanceModel> toModel(ParseObject parseObject,
      [List<String> cols = const []]) async {
    print('AttendanceEntity.toModel cols $cols');
    AttendanceModel model = AttendanceModel(
      id: parseObject.objectId!,
      professional: parseObject.get(AttendanceEntity.professional) != null
          ? await UserProfileEntity()
              .toModel(parseObject.get(AttendanceEntity.professional), cols)
          : null,
      procedure: parseObject.get(AttendanceEntity.procedure) != null
          ? ProcedureEntity()
              .toModel(parseObject.get(AttendanceEntity.procedure))
          : null,
      patient: parseObject.get(AttendanceEntity.patient) != null
          ? await PatientEntity()
              .toModel(parseObject.get(AttendanceEntity.patient), cols)
          : null,
      healthPlan: parseObject.get(AttendanceEntity.healthPlan) != null
          ? HealthPlanEntity()
              .toModel(parseObject.get(AttendanceEntity.healthPlan))
          : null,
      authorizationCode: parseObject.get(AttendanceEntity.authorizationCode),
      authorizationDateCreated: parseObject
          .get<DateTime>(AttendanceEntity.authorizationDateCreated)
          ?.toLocal(),
      authorizationDateLimit: parseObject
          .get<DateTime>(AttendanceEntity.authorizationDateLimit)
          ?.toLocal(),
      attendance:
          parseObject.get<DateTime>(AttendanceEntity.attendance)?.toLocal(),
      confirmedPresence: parseObject
          .get<DateTime>(AttendanceEntity.confirmedPresence)
          ?.toLocal(),
      description: parseObject.get(AttendanceEntity.description),
      status: parseObject.get(AttendanceEntity.status) != null
          ? StatusEntity().toModel(parseObject.get(AttendanceEntity.status))
          : null,
    );
    return model;
  }

  Future<ParseObject> toParse(AttendanceModel model) async {
    final parseObject = ParseObject(AttendanceEntity.className);
    parseObject.objectId = model.id;

    if (model.professional != null) {
      parseObject.set(
          AttendanceEntity.professional,
          (ParseObject(UserProfileEntity.className)
                ..objectId = model.professional!.id)
              .toPointer());
    }

    if (model.procedure != null) {
      parseObject.set(
          AttendanceEntity.procedure,
          (ParseObject(ProcedureEntity.className)
                ..objectId = model.procedure!.id)
              .toPointer());
    }
    if (model.patient != null) {
      parseObject.set(
          AttendanceEntity.patient,
          (ParseObject(PatientEntity.className)..objectId = model.patient!.id)
              .toPointer());
    }
    if (model.healthPlan != null) {
      parseObject.set(
          AttendanceEntity.healthPlan,
          (ParseObject(HealthPlanEntity.className)
                ..objectId = model.healthPlan!.id)
              .toPointer());
    }
    if (model.authorizationCode != null) {
      parseObject.set(
          AttendanceEntity.authorizationCode, model.authorizationCode);
    }

    if (model.authorizationDateCreated != null) {
      parseObject.set<DateTime?>(
          AttendanceEntity.authorizationDateCreated,
          DateTime(
              model.authorizationDateCreated!.year,
              model.authorizationDateCreated!.month,
              model.authorizationDateCreated!.day));
    }
    if (model.authorizationDateLimit != null) {
      parseObject.set<DateTime?>(
          AttendanceEntity.authorizationDateLimit,
          DateTime(
              model.authorizationDateLimit!.year,
              model.authorizationDateLimit!.month,
              model.authorizationDateLimit!.day));
    }
    if (model.attendance != null) {
      parseObject.set<DateTime?>(AttendanceEntity.attendance, model.attendance);
    }
    if (model.confirmedPresence != null) {
      parseObject.set<DateTime?>(
          AttendanceEntity.confirmedPresence, model.confirmedPresence);
    }
    if (model.description != null) {
      parseObject.set(AttendanceEntity.description, model.description);
    }
    if (model.status != null) {
      parseObject.set(
          AttendanceEntity.status,
          (ParseObject(StatusEntity.className)..objectId = model.status!.id)
              .toPointer());
    }

    return parseObject;
  }
}
