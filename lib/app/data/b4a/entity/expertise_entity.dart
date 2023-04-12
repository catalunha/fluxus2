import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/expertise_model.dart';

class ExpertiseEntity {
  static const String className = 'Expertise';
  static const String id = 'objectId';
  static const String name = 'name';

  ExpertiseModel toModel(ParseObject parseObject) {
    ExpertiseModel model = ExpertiseModel(
      id: parseObject.objectId!,
      name: parseObject.get(ExpertiseEntity.name),
    );
    return model;
  }

  Future<ParseObject> toParse(ExpertiseModel model) async {
    final parseObject = ParseObject(ExpertiseEntity.className);
    parseObject.objectId = model.id;

    if (model.name != null) {
      parseObject.set(ExpertiseEntity.name, model.name);
    }

    return parseObject;
  }
}
