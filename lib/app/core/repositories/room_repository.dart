import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/room_b4a.dart';
import '../../data/utils/pagination.dart';
import '../models/room_model.dart';

class RoomRepository {
  final RoomB4a apiB4a = RoomB4a();

  RoomRepository();
  Future<List<RoomModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) =>
      apiB4a.list(query, pagination);
  Future<String> update(RoomModel model) => apiB4a.update(model);
  Future<bool> delete(String modelId) => apiB4a.delete(modelId);
}
