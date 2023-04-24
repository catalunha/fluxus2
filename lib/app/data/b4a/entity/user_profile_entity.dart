import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/expertise_model.dart';
import '../../../core/models/office_model.dart';
import '../../../core/models/procedure_model.dart';
import '../../../core/models/user_profile_model.dart';
import 'expertise_entity.dart';
import 'office_entity.dart';
import 'procedure_entity.dart';
import 'region_entity.dart';

class UserProfileEntity {
  static const String className = 'UserProfile';

  static const String id = 'objectId';
  static const String email = 'email';
  static const String nickname = 'nickname';
  static const String name = 'name';
  static const String cpf = 'cpf';
  static const String register = 'register';
  static const String phone = 'phone';
  static const String photo = 'photo';
  static const String isFemale = 'isFemale';
  static const String isActive = 'isActive';
  static const String birthday = 'birthday';
  static const String address = 'address';
  static const String access = 'access';

  static const String region = 'region';

  static const String offices = 'offices';
  static const String expertises = 'expertises';
  static const String procedures = 'procedures';

  static List<String> selectedCols(List<String> cols) {
    return cols.map((e) => '${UserProfileEntity.className}.$e').toList();
  }

  static final List<String> singleCols = [
    UserProfileEntity.email,
    UserProfileEntity.nickname,
    UserProfileEntity.name,
    UserProfileEntity.cpf,
    UserProfileEntity.register,
    UserProfileEntity.phone,
    UserProfileEntity.photo,
    UserProfileEntity.isFemale,
    UserProfileEntity.isActive,
    UserProfileEntity.birthday,
    UserProfileEntity.address,
    UserProfileEntity.access,
  ].map((e) => '${UserProfileEntity.className}.$e').toList();
  static final List<String> pointerCols = [
    UserProfileEntity.region,
  ].map((e) => '${UserProfileEntity.className}.$e').toList();

  static final List<String> relationCols = [
    UserProfileEntity.offices,
    UserProfileEntity.expertises,
    UserProfileEntity.procedures,
  ].map((e) => '${UserProfileEntity.className}.$e').toList();

  static final List<String> allCols = [
    ...UserProfileEntity.singleCols,
    ...UserProfileEntity.pointerCols,
    ...UserProfileEntity.relationCols
  ];
  static List<String> filterSingleCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (UserProfileEntity.singleCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${UserProfileEntity.className}.', ''))
        .toList();
  }

  static List<String> filterPointerCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (UserProfileEntity.pointerCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${UserProfileEntity.className}.', ''))
        .toList();
  }

  static List<String> filterRelationCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (UserProfileEntity.relationCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${UserProfileEntity.className}.', ''))
        .toList();
  }

  Future<UserProfileModel> toModel(
    ParseObject parseObject, [
    List<String> cols = const [],
  ]) async {
    //+++ get office
    List<OfficeModel> officeList = [];
    // if (cols.contains('offices')) {
    if (cols.contains(
        '${UserProfileEntity.className}.${UserProfileEntity.offices}')) {
      QueryBuilder<ParseObject> queryOffice =
          QueryBuilder<ParseObject>(ParseObject(OfficeEntity.className));
      queryOffice.whereRelatedTo(UserProfileEntity.offices,
          UserProfileEntity.className, parseObject.objectId!);
      List<String> colsOffices = cols
          .where((e) => e.startsWith('${OfficeEntity.className}.'))
          .toList();
      print('colsOffices: $colsOffices');
      queryOffice.keysToReturn([
        ...OfficeEntity.filterSingleCols(colsOffices),
        ...OfficeEntity.filterPointerCols(colsOffices),
        ...OfficeEntity.filterRelationCols(colsOffices)
      ]);
      queryOffice.includeObject(OfficeEntity.filterPointerCols(colsOffices));
      final ParseResponse parseResponse = await queryOffice.query();
      if (parseResponse.success && parseResponse.results != null) {
        for (var e in parseResponse.results!) {
          officeList.add(OfficeEntity().toModel(e as ParseObject));
        }
      }
    }

    //--- get office
    //+++ get expertise
    List<ExpertiseModel> expertiseList = [];

    // if (cols.contains('expertises')) {
    if (cols.contains(
        '${UserProfileEntity.className}.${UserProfileEntity.expertises}')) {
      QueryBuilder<ParseObject> queryExpertise =
          QueryBuilder<ParseObject>(ParseObject(ExpertiseEntity.className));
      queryExpertise.whereRelatedTo(UserProfileEntity.expertises,
          UserProfileEntity.className, parseObject.objectId!);
      List<String> colsExpertises = cols
          .where((e) => e.startsWith('${ExpertiseEntity.className}.'))
          .toList();
      queryExpertise.keysToReturn([
        ...ExpertiseEntity.filterSingleCols(colsExpertises),
        ...ExpertiseEntity.filterPointerCols(colsExpertises),
        ...ExpertiseEntity.filterRelationCols(colsExpertises)
      ]);
      queryExpertise
          .includeObject(ExpertiseEntity.filterPointerCols(colsExpertises));
      final ParseResponse parseResponse = await queryExpertise.query();
      if (parseResponse.success && parseResponse.results != null) {
        for (var e in parseResponse.results!) {
          expertiseList.add(ExpertiseEntity().toModel(e as ParseObject));
        }
      }
    }

    //--- get expertise
    //+++ get procedure
    List<ProcedureModel> procedureList = [];

    // if (cols.contains('procedures')) {
    if (cols.contains(
        '${UserProfileEntity.className}.${UserProfileEntity.procedures}')) {
      QueryBuilder<ParseObject> queryProcedure =
          QueryBuilder<ParseObject>(ParseObject(ProcedureEntity.className));
      queryProcedure.whereRelatedTo(UserProfileEntity.procedures,
          UserProfileEntity.className, parseObject.objectId!);
      List<String> colsProcedures = cols
          .where((e) => e.startsWith('${ProcedureEntity.className}.'))
          .toList();
      queryProcedure.keysToReturn([
        ...ProcedureEntity.filterSingleCols(colsProcedures),
        ...ProcedureEntity.filterPointerCols(colsProcedures),
        ...ProcedureEntity.filterRelationCols(colsProcedures)
      ]);
      queryProcedure
          .includeObject(ProcedureEntity.filterPointerCols(colsProcedures));
      // queryProcedure.includeObject(['expertise']);
      final ParseResponse parseResponse = await queryProcedure.query();
      if (parseResponse.success && parseResponse.results != null) {
        for (var e in parseResponse.results!) {
          procedureList.add(ProcedureEntity().toModel(e as ParseObject));
        }
      }
    }

    //--- get procedure
    UserProfileModel model = UserProfileModel(
      id: parseObject.objectId!,
      email: parseObject.get(UserProfileEntity.email),
      nickname: parseObject.get(UserProfileEntity.nickname),
      name: parseObject.get(UserProfileEntity.name),
      cpf: parseObject.get(UserProfileEntity.cpf),
      register: parseObject.get(UserProfileEntity.register),
      phone: parseObject.get(UserProfileEntity.phone),
      address: parseObject.get(UserProfileEntity.address),
      photo: parseObject.get(UserProfileEntity.photo)?.get('url'),
      isFemale: parseObject.get(UserProfileEntity.isFemale),
      isActive: parseObject.get(UserProfileEntity.isActive),
      birthday:
          parseObject.get<DateTime>(UserProfileEntity.birthday)?.toLocal(),
      access: parseObject.get<List<dynamic>>(UserProfileEntity.access) != null
          ? parseObject
              .get<List<dynamic>>(UserProfileEntity.access)!
              .map((e) => e.toString())
              .toList()
          : [],
      region: parseObject.containsKey(UserProfileEntity.region) &&
              parseObject.get(UserProfileEntity.region) != null
          ? RegionEntity().toModel(parseObject.get(UserProfileEntity.region))
          : null,
      offices: officeList,
      expertises: expertiseList,
      procedures: procedureList,
    );
    return model;
  }

  Future<ParseObject> toParse(UserProfileModel model) async {
    final parseObject = ParseObject(UserProfileEntity.className);
    parseObject.objectId = model.id;

    if (model.nickname != null) {
      parseObject.set(UserProfileEntity.nickname, model.nickname);
    }
    if (model.name != null) {
      parseObject.set(UserProfileEntity.name, model.name);
    }
    if (model.cpf != null) {
      parseObject.set(UserProfileEntity.cpf, model.cpf);
    }
    if (model.register != null) {
      parseObject.set(UserProfileEntity.register, model.register);
    }

    if (model.phone != null) {
      parseObject.set(UserProfileEntity.phone, model.phone);
    }
    if (model.address != null) {
      parseObject.set(UserProfileEntity.address, model.address);
    }

    if (model.isFemale != null) {
      parseObject.set(UserProfileEntity.isFemale, model.isFemale);
    }

    if (model.birthday != null) {
      parseObject.set<DateTime?>(
          UserProfileEntity.birthday,
          DateTime(model.birthday!.year, model.birthday!.month,
              model.birthday!.day));
    }
    if (model.region != null) {
      parseObject.set(
          UserProfileEntity.region,
          (ParseObject(RegionEntity.className)..objectId = model.region!.id)
              .toPointer());
    }
    parseObject.set(UserProfileEntity.access, model.access);

    parseObject.set(UserProfileEntity.isActive, model.isActive);
    return parseObject;
  }

  ParseObject? toParseRelationOffices({
    required String objectId,
    required List<String> ids,
    required bool add,
  }) {
    final parseObject = ParseObject(UserProfileEntity.className);
    parseObject.objectId = objectId;
    if (ids.isEmpty) {
      parseObject.unset(UserProfileEntity.offices);
      return parseObject;
    }
    if (add) {
      parseObject.addRelation(
        UserProfileEntity.offices,
        ids
            .map(
              (element) =>
                  ParseObject(OfficeEntity.className)..objectId = element,
            )
            .toList(),
      );
    } else {
      parseObject.removeRelation(
          UserProfileEntity.offices,
          ids
              .map((element) =>
                  ParseObject(OfficeEntity.className)..objectId = element)
              .toList());
    }
    return parseObject;
  }

  ParseObject? toParseRelationExpertises({
    required String objectId,
    required List<String> ids,
    required bool add,
  }) {
    final parseObject = ParseObject(UserProfileEntity.className);
    parseObject.objectId = objectId;
    if (ids.isEmpty) {
      parseObject.unset(UserProfileEntity.expertises);
      return parseObject;
    }
    if (add) {
      parseObject.addRelation(
        UserProfileEntity.expertises,
        ids
            .map(
              (element) =>
                  ParseObject(ExpertiseEntity.className)..objectId = element,
            )
            .toList(),
      );
    } else {
      parseObject.removeRelation(
          UserProfileEntity.expertises,
          ids
              .map((element) =>
                  ParseObject(ExpertiseEntity.className)..objectId = element)
              .toList());
    }
    return parseObject;
  }

  ParseObject? toParseRelationProcedures({
    required String objectId,
    required List<String> ids,
    required bool add,
  }) {
    final parseObject = ParseObject(UserProfileEntity.className);
    parseObject.objectId = objectId;
    if (ids.isEmpty) {
      parseObject.unset(UserProfileEntity.procedures);
      return parseObject;
    }
    if (add) {
      parseObject.addRelation(
        UserProfileEntity.procedures,
        ids
            .map(
              (element) =>
                  ParseObject(ProcedureEntity.className)..objectId = element,
            )
            .toList(),
      );
    } else {
      parseObject.removeRelation(
          UserProfileEntity.procedures,
          ids
              .map((element) =>
                  ParseObject(ProcedureEntity.className)..objectId = element)
              .toList());
    }
    return parseObject;
  }
}
