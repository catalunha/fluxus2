import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/event_b4a.dart';
import '../models/event_model.dart';
import '../../data/utils/pagination.dart';

class EventRepository {
  final EventB4a apiB4a = EventB4a();

  EventRepository();
  Future<List<EventModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) =>
      apiB4a.list(query, pagination);
  Future<String> update(EventModel userProfileModel) =>
      apiB4a.update(userProfileModel);
  Future<EventModel?> readById(String id) => apiB4a.readById(id);

  Future<void> updateRelationAttendances(
          String objectId, List<String> ids, bool add) =>
      apiB4a.updateRelationAttendances(objectId: objectId, ids: ids, add: add);
}
