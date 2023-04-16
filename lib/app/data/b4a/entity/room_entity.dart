import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/room_model.dart';

class RoomEntity {
  static const String className = 'Room';
  static const String id = 'objectId';
  static const String name = 'name';
  static const String isActive = 'isActive';

  RoomModel toModel(ParseObject parseObject) {
    RoomModel model = RoomModel(
      id: parseObject.objectId!,
      name: parseObject.get(RoomEntity.name),
      isActive: parseObject.get(RoomEntity.isActive),
    );
    return model;
  }

  Future<ParseObject> toParse(RoomModel model) async {
    final parseObject = ParseObject(RoomEntity.className);
    parseObject.objectId = model.id;

    if (model.name != null) {
      parseObject.set(RoomEntity.name, model.name);
    }
    if (model.isActive != null) {
      parseObject.set(RoomEntity.isActive, model.isActive);
    }
    return parseObject;
  }
}
