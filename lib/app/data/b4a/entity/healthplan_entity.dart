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

  HealthPlanModel toModel(ParseObject parseObject) {
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
