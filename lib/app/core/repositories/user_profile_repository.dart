import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/user_profile_b4a.dart';
import '../models/user_profile_model.dart';
import '../../data/utils/pagination.dart';

class UserProfileRepository {
  final UserProfileB4a userProfileB4a = UserProfileB4a();

  UserProfileRepository();
  Future<List<UserProfileModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination, [
    List<String> cols = const [],
  ]) =>
      userProfileB4a.list(query, pagination, cols);
  Future<String> update(UserProfileModel userProfileModel) =>
      userProfileB4a.update(userProfileModel);
  Future<UserProfileModel?> readById(String id,
          [List<String> cols = const []]) =>
      userProfileB4a.readById(id, cols);
  // Future<UserProfileModel?> readByCPF(String? value) =>
  //     userProfileB4a.readByCPF(value);
  Future<void> updateRelationOffices(
          String objectId, List<String> ids, bool add) =>
      userProfileB4a.updateRelationOffices(
          objectId: objectId, ids: ids, add: add);
  Future<void> updateRelationExpertises(
          String objectId, List<String> ids, bool add) =>
      userProfileB4a.updateRelationExpertises(
          objectId: objectId, ids: ids, add: add);
  Future<void> updateRelationProcedures(
          String objectId, List<String> ids, bool add) =>
      userProfileB4a.updateRelationProcedures(
          objectId: objectId, ids: ids, add: add);
}
