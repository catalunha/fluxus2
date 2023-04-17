import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/office_b4a.dart';
import '../../data/utils/pagination.dart';
import '../models/office_model.dart';

class OfficeRepository {
  final OfficeB4a apiB4a = OfficeB4a();

  OfficeRepository();
  Future<List<OfficeModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) =>
      apiB4a.list(query, pagination);
  Future<String> update(OfficeModel model) => apiB4a.update(model);
  Future<bool> delete(String modelId) => apiB4a.delete(modelId);
}
