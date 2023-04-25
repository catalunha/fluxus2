import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/healthplan_model.dart';
import '../../../core/models/patient_model.dart';
import 'healthplan_entity.dart';
import 'region_entity.dart';

class PatientEntity {
  static const String className = 'Patient';
  //SingleCols
  static const String id = 'objectId';
  static const String email = 'email';
  static const String name = 'name';
  static const String nickname = 'nickname';
  static const String cpf = 'cpf';
  static const String phone = 'phone';
  static const String isFemale = 'isFemale';
  static const String birthday = 'birthday';
  static const String address = 'address';
  //PointerCols
  static const String region = 'region';
  //RelationCols
  static const String family = 'family';
  static const String healthPlans = 'healthPlans';

  static List<String> selectedCols(List<String> cols) {
    return cols.map((e) => '${PatientEntity.className}.$e').toList();
  }

  static final List<String> singleCols = [
    PatientEntity.email,
    PatientEntity.name,
    PatientEntity.nickname,
    PatientEntity.cpf,
    PatientEntity.phone,
    PatientEntity.isFemale,
    PatientEntity.birthday,
    PatientEntity.address,
    PatientEntity.region,
    PatientEntity.family,
    PatientEntity.healthPlans
  ].map((e) => '${PatientEntity.className}.$e').toList();

  static final List<String> pointerCols = [
    PatientEntity.region,
  ].map((e) => '${PatientEntity.className}.$e').toList();

  static final List<String> relationCols = [
    PatientEntity.family,
    PatientEntity.healthPlans
  ].map((e) => '${PatientEntity.className}.$e').toList();

  // static final List<String> allCols = [
  //   ...PatientEntity.singleCols,
  //   ...PatientEntity.pointerCols,
  //   ...PatientEntity.relationCols
  // ];

  static List<String> filterSingleCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (PatientEntity.singleCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${PatientEntity.className}.', ''))
        .toList();
  }

  static List<String> filterPointerCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (PatientEntity.pointerCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${PatientEntity.className}.', ''))
        .toList();
  }

  static List<String> filterRelationCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (PatientEntity.relationCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${PatientEntity.className}.', ''))
        .toList();
  }

  Future<PatientModel> toModel(ParseObject parseObject,
      [List<String> cols = const []]) async {
    print('PatientEntity.toModel cols: $cols');
    //+++ get family
    List<PatientModel> familyList = [];
    if (cols.contains('${PatientEntity.className}.${PatientEntity.family}')) {
      QueryBuilder<ParseObject> queryPatient =
          QueryBuilder<ParseObject>(ParseObject(PatientEntity.className));
      queryPatient.whereRelatedTo(
          PatientEntity.family, PatientEntity.className, parseObject.objectId!);
      queryPatient.keysToReturn([PatientEntity.name]);
      final ParseResponse parseResponse = await queryPatient.query();
      if (parseResponse.success && parseResponse.results != null) {
        for (var e in parseResponse.results!) {
          familyList.add(await PatientEntity().toModel(e as ParseObject,
              ['${PatientEntity.className}.${PatientEntity.name}']));
        }
      }
    }

    //--- get family
    //+++ get healthPlan
    List<HealthPlanModel> healthPlanList = [];
    if (cols
        .contains('${PatientEntity.className}.${PatientEntity.healthPlans}')) {
      QueryBuilder<ParseObject> queryHealthPlanType =
          QueryBuilder<ParseObject>(ParseObject(HealthPlanEntity.className));
      queryHealthPlanType.whereRelatedTo(PatientEntity.healthPlans,
          PatientEntity.className, parseObject.objectId!);
      List<String> colsHealthPlans = cols
          .where((e) => e.startsWith('${HealthPlanEntity.className}.'))
          .toList();
      queryHealthPlanType.keysToReturn([
        ...HealthPlanEntity.filterSingleCols(colsHealthPlans),
        ...HealthPlanEntity.filterPointerCols(colsHealthPlans),
        ...HealthPlanEntity.filterRelationCols(colsHealthPlans)
      ]);
      queryHealthPlanType
          .includeObject(HealthPlanEntity.filterPointerCols(colsHealthPlans));
      final ParseResponse parseResponse = await queryHealthPlanType.query();
      if (parseResponse.success && parseResponse.results != null) {
        for (var e in parseResponse.results!) {
          healthPlanList.add(HealthPlanEntity().toModel(e as ParseObject));
        }
      }
    }

    //--- get healthPlan

    PatientModel model = PatientModel(
      id: parseObject.objectId!,
      email: parseObject.get(PatientEntity.email),
      nickname: parseObject.get(PatientEntity.nickname),
      name: parseObject.get(PatientEntity.name),
      cpf: parseObject.get(PatientEntity.cpf),
      phone: parseObject.get(PatientEntity.phone),
      address: parseObject.get(PatientEntity.address),
      isFemale: parseObject.get(PatientEntity.isFemale),
      birthday: parseObject.get<DateTime>(PatientEntity.birthday)?.toLocal(),
      region: parseObject.get(PatientEntity.region) != null
          ? RegionEntity().toModel(parseObject.get(PatientEntity.region), cols)
          : null,
      family: familyList,
      healthPlans: healthPlanList,
    );
    return model;
  }

  // PatientModel toModelSingleData(ParseObject parseObject) {
  //   PatientModel model = PatientModel(
  //     id: parseObject.objectId!,
  //     email: parseObject.get(PatientEntity.email),
  //     nickname: parseObject.get(PatientEntity.nickname),
  //     name: parseObject.get(PatientEntity.name),
  //     cpf: parseObject.get(PatientEntity.cpf),
  //     phone: parseObject.get(PatientEntity.phone),
  //     address: parseObject.get(PatientEntity.address),
  //     isFemale: parseObject.get(PatientEntity.isFemale),
  //   );
  //   return model;
  // }

  Future<ParseObject> toParse(PatientModel model) async {
    final parseObject = ParseObject(PatientEntity.className);
    parseObject.objectId = model.id;

    if (model.nickname != null) {
      parseObject.set(PatientEntity.nickname, model.nickname);
    }
    if (model.name != null) {
      parseObject.set(PatientEntity.name, model.name);
    }
    if (model.cpf != null) {
      parseObject.set(PatientEntity.cpf, model.cpf);
    }

    if (model.phone != null) {
      parseObject.set(PatientEntity.phone, model.phone);
    }
    if (model.address != null) {
      parseObject.set(PatientEntity.address, model.address);
    }

    if (model.isFemale != null) {
      parseObject.set(PatientEntity.isFemale, model.isFemale);
    }

    if (model.birthday != null) {
      parseObject.set<DateTime?>(
          PatientEntity.birthday,
          DateTime(model.birthday!.year, model.birthday!.month,
              model.birthday!.day));
    }
    if (model.region != null) {
      parseObject.set(
          PatientEntity.region,
          (ParseObject(RegionEntity.className)..objectId = model.region!.id)
              .toPointer());
    }

    return parseObject;
  }

  ParseObject? toParseRelationFamily({
    required String objectId,
    required List<String> ids,
    required bool add,
  }) {
    final parseObject = ParseObject(PatientEntity.className);
    parseObject.objectId = objectId;
    if (ids.isEmpty) {
      parseObject.unset(PatientEntity.family);
      return parseObject;
    }
    if (add) {
      parseObject.addRelation(
        PatientEntity.family,
        ids
            .map(
              (element) =>
                  ParseObject(PatientEntity.className)..objectId = element,
            )
            .toList(),
      );
    } else {
      parseObject.removeRelation(
          PatientEntity.family,
          ids
              .map((element) =>
                  ParseObject(PatientEntity.className)..objectId = element)
              .toList());
    }
    return parseObject;
  }

  ParseObject? toParseRelationHealthPlans({
    required String objectId,
    required List<String> ids,
    required bool add,
  }) {
    final parseObject = ParseObject(PatientEntity.className);
    parseObject.objectId = objectId;
    if (ids.isEmpty) {
      parseObject.unset(PatientEntity.healthPlans);
      return parseObject;
    }
    if (add) {
      parseObject.addRelation(
        PatientEntity.healthPlans,
        ids
            .map(
              (element) =>
                  ParseObject(HealthPlanEntity.className)..objectId = element,
            )
            .toList(),
      );
    } else {
      parseObject.removeRelation(
          PatientEntity.healthPlans,
          ids
              .map((element) =>
                  ParseObject(HealthPlanEntity.className)..objectId = element)
              .toList());
    }
    return parseObject;
  }
}
