import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/graduation_model.dart';

class GraduationEntity {
  static const String className = 'Graduation';
  static const String id = 'objectId';
  static const String name = 'name';

  GraduationModel toModel(ParseObject parseObject) {
    GraduationModel model = GraduationModel(
      id: parseObject.objectId!,
      name: parseObject.get(GraduationEntity.name),
    );
    return model;
  }

  Future<ParseObject> toParse(GraduationModel model) async {
    final parseObject = ParseObject(GraduationEntity.className);
    parseObject.objectId = model.id;

    if (model.name != null) {
      parseObject.set(GraduationEntity.name, model.name);
    }

    return parseObject;
  }
}
