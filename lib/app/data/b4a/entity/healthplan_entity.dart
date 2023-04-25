import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/healthplan_model.dart';
import 'healthplantype_entity.dart';

class HealthPlanEntity {
  static const String className = 'HealthPlan';
  // Nome do campo local =  no Database
  static const String id = 'objectId';
  static const String code = 'code';
  static const String due = 'due';
  static const String description = 'description';
  static const String healthPlanType = 'healthPlanType';
  static List<String> selectedCols(List<String> cols) {
    return cols.map((e) => '${HealthPlanEntity.className}.$e').toList();
  }

  static final List<String> singleCols = [
    HealthPlanEntity.code,
    HealthPlanEntity.due,
    HealthPlanEntity.description,
    HealthPlanEntity.healthPlanType,
  ].map((e) => '${HealthPlanEntity.className}.$e').toList();

  static final List<String> pointerCols = [
    HealthPlanEntity.healthPlanType,
  ].map((e) => '${HealthPlanEntity.className}.$e').toList();

  static final List<String> relationCols =
      [].map((e) => '${HealthPlanEntity.className}.$e').toList();

  // static final List<String> allCols = [
  //   ...HealthPlanEntity.singleCols,
  //   ...HealthPlanEntity.pointerCols,
  //   ...HealthPlanEntity.relationCols
  // ];

  static List<String> filterSingleCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (HealthPlanEntity.singleCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${HealthPlanEntity.className}.', ''))
        .toList();
  }

  static List<String> filterPointerCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (HealthPlanEntity.pointerCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${HealthPlanEntity.className}.', ''))
        .toList();
  }

  static List<String> filterRelationCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (HealthPlanEntity.relationCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${HealthPlanEntity.className}.', ''))
        .toList();
  }

  HealthPlanModel toModel(ParseObject parseObject,
      [List<String> cols = const []]) {
    HealthPlanModel model = HealthPlanModel(
      id: parseObject.objectId!,
      code: parseObject.get(HealthPlanEntity.code),
      due: parseObject.get<DateTime>(HealthPlanEntity.due)?.toLocal(),
      description: parseObject.get(HealthPlanEntity.description),
      healthPlanType: parseObject.get(HealthPlanEntity.healthPlanType) != null
          ? HealthPlanTypeEntity()
              .toModel(parseObject.get(HealthPlanEntity.healthPlanType))
          : null,
    );
    return model;
  }

  Future<ParseObject> toParse(HealthPlanModel model) async {
    final parseObject = ParseObject(HealthPlanEntity.className);
    parseObject.objectId = model.id;
    if (model.description != null) {
      parseObject.set(HealthPlanEntity.description, model.description);
    }
    if (model.code != null) {
      parseObject.set(HealthPlanEntity.code, model.code);
    }
    if (model.due != null) {
      parseObject.set<DateTime?>(HealthPlanEntity.due,
          DateTime(model.due!.year, model.due!.month, model.due!.day));
    }
    if (model.description != null) {
      parseObject.set(HealthPlanEntity.description, model.description);
    }

    if (model.healthPlanType != null) {
      parseObject.set(
          HealthPlanEntity.healthPlanType,
          (ParseObject(HealthPlanTypeEntity.className)
                ..objectId = model.healthPlanType!.id)
              .toPointer());
    }
    return parseObject;
  }
}
