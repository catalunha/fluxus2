import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/patient_b4a.dart';
import '../models/patient_model.dart';
import '../../data/utils/pagination.dart';

class PatientRepository {
  final PatientB4a apiB4a = PatientB4a();

  PatientRepository();
  Future<List<PatientModel>> list(
          QueryBuilder<ParseObject> query, Pagination pagination,
          [List<String> cols = const []]) =>
      apiB4a.list(query, pagination, cols);
  Future<String> update(PatientModel userProfileModel) =>
      apiB4a.update(userProfileModel);
  Future<PatientModel?> readById(String id, [List<String> cols = const []]) =>
      apiB4a.readById(id, cols);

  Future<void> updateRelationFamily(
          String objectId, List<String> ids, bool add) =>
      apiB4a.updateRelationFamily(objectId: objectId, ids: ids, add: add);
  Future<void> updateRelationHealthPlans(
          String objectId, List<String> ids, bool add) =>
      apiB4a.updateRelationHealthPlans(objectId: objectId, ids: ids, add: add);
}
