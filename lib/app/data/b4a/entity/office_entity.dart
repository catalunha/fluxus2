import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/office_model.dart';

class OfficeEntity {
  static const String className = 'Office';
  static const String id = 'objectId';
  static const String name = 'name';

  OfficeModel toModel(ParseObject parseObject) {
    OfficeModel model = OfficeModel(
      id: parseObject.objectId!,
      name: parseObject.get(OfficeEntity.name),
    );
    return model;
  }

  Future<ParseObject> toParse(OfficeModel model) async {
    final parseObject = ParseObject(OfficeEntity.className);
    parseObject.objectId = model.id;

    if (model.name != null) {
      parseObject.set(OfficeEntity.name, model.name);
    }

    return parseObject;
  }
}
