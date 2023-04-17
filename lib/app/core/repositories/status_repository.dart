import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/status_b4a.dart';
import '../../data/utils/pagination.dart';
import '../models/status_model.dart';

class StatusRepository {
  final StatusB4a apiB4a = StatusB4a();

  StatusRepository();
  Future<List<StatusModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) =>
      apiB4a.list(query, pagination);
  Future<String> update(StatusModel model) => apiB4a.update(model);
  Future<bool> delete(String modelId) => apiB4a.delete(modelId);
}
