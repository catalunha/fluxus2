import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/event_model.dart';

class EventEntity {
  static const String className = 'Event';
  static const String id = 'objectId';

  EventModel toModel(ParseObject parseObject) {
    EventModel model = EventModel(
      id: parseObject.objectId!,
    );
    return model;
  }

  Future<ParseObject> toParse(EventModel model) async {
    final parseObject = ParseObject(EventEntity.className);
    parseObject.objectId = model.id;

    return parseObject;
  }
}
