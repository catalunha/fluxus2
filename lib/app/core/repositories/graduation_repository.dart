import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/graduation_b4a.dart';
import '../../data/utils/pagination.dart';
import '../models/graduation_model.dart';

class GraduationRepository {
  final GraduationB4a apiB4a = GraduationB4a();

  GraduationRepository();
  Future<List<GraduationModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) =>
      apiB4a.list(query, pagination);
  Future<String> update(GraduationModel model) => apiB4a.update(model);
  Future<bool> delete(String modelId) => apiB4a.delete(modelId);
}
