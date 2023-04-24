import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/evolution_model.dart';

class EvolutionEntity {
  static const String className = 'Evolution';
  static const String id = 'objectId';

  EvolutionModel toModel(ParseObject parseObject) {
    EvolutionModel model = EvolutionModel(
      id: parseObject.objectId!,
    );
    return model;
  }

  Future<ParseObject> toParse(EvolutionModel model) async {
    final parseObject = ParseObject(EvolutionEntity.className);
    parseObject.objectId = model.id;

    return parseObject;
  }
}
