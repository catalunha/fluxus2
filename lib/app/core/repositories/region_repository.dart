import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/region_b4a.dart';
import '../../data/utils/pagination.dart';
import '../models/region_model.dart';

class RegionRepository {
  final RegionB4a secretaryB4a = RegionB4a();

  RegionRepository();
  Future<List<RegionModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) =>
      secretaryB4a.list(query, pagination);
  Future<String> update(RegionModel model) => secretaryB4a.update(model);
  Future<bool> delete(String modelId) => secretaryB4a.delete(modelId);
}
