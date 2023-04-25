import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/expertise_b4a.dart';
import '../../data/utils/pagination.dart';
import '../models/expertise_model.dart';

class ExpertiseRepository {
  final ExpertiseB4a apiB4a = ExpertiseB4a();

  ExpertiseRepository();
  Future<List<ExpertiseModel>> list(
          QueryBuilder<ParseObject> query, Pagination pagination,
          [List<String> cols = const []]) =>
      apiB4a.list(query, pagination, cols);
  Future<String> update(ExpertiseModel model) => apiB4a.update(model);
  Future<bool> delete(String modelId) => apiB4a.delete(modelId);
}
