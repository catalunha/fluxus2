import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/healthplantype_b4a.dart';
import '../../data/utils/pagination.dart';
import '../models/healthplantype_model.dart';

class HealthPlanTypeRepository {
  final HealthPlanTypeB4a apiB4a = HealthPlanTypeB4a();

  HealthPlanTypeRepository();
  Future<List<HealthPlanTypeModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) =>
      apiB4a.list(query, pagination);
  Future<String> update(HealthPlanTypeModel model) => apiB4a.update(model);
  Future<bool> delete(String modelId) => apiB4a.delete(modelId);
}
