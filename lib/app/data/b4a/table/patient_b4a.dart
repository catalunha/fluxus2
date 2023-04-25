import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/patient_model.dart';
import '../../utils/pagination.dart';
import '../b4a_exception.dart';
import '../entity/patient_entity.dart';
import '../utils/parse_error_translate.dart';

class PatientB4a {
  Future<QueryBuilder<ParseObject>> getQueryAll(
      QueryBuilder<ParseObject> query, Pagination pagination,
      [List<String> cols = const []]) async {
    query.setAmountToSkip((pagination.page - 1) * pagination.limit);
    query.setLimit(pagination.limit);

    query.keysToReturn([
      ...PatientEntity.filterSingleCols(cols),
    ]);
    query.includeObject(PatientEntity.filterPointerCols(cols));

    return query;
  }

  Future<List<PatientModel>> list(
      QueryBuilder<ParseObject> query, Pagination pagination,
      [List<String> cols = const []]) async {
    QueryBuilder<ParseObject> query2;
    query2 = await getQueryAll(query, pagination, cols);
    ParseResponse? response;
    try {
      response = await query2.query();
      List<PatientModel> listTemp = <PatientModel>[];
      if (response.success && response.results != null) {
        for (var element in response.results!) {
          listTemp.add(await PatientEntity().toModel(element, cols));
        }
        return listTemp;
      } else {
        return [];
      }
    } on Exception {
      var errorTranslated = ParseErrorTranslate.translate(response!.error!);
      throw B4aException(
        errorTranslated,
        where: 'PatientRepositoryB4a.list',
        originalError: '${response.error!.code} -${response.error!.message}',
      );
    }
  }

  Future<PatientModel?> readById(String id,
      [List<String> cols = const []]) async {
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(PatientEntity.className));
    query.whereEqualTo(PatientEntity.id, id);
    query.keysToReturn([
      ...PatientEntity.filterSingleCols(cols),
    ]);
    query.includeObject(PatientEntity.filterPointerCols(cols));
    query.first();
    try {
      var response = await query.query();

      if (response.success && response.results != null) {
        return PatientEntity().toModel(response.results!.first, cols);
      }
      throw B4aException(
        'Perfil do usuário não encontrado.',
        where: 'PatientRepositoryB4a.readById()',
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<String> update(PatientModel userProfileModel) async {
    final userProfileParse = await PatientEntity().toParse(userProfileModel);
    ParseResponse? response;
    try {
      response = await userProfileParse.save();

      if (response.success && response.results != null) {
        ParseObject userProfile = response.results!.first as ParseObject;
        return userProfile.objectId!;
      } else {
        throw Exception();
      }
    } on Exception {
      var errorTranslated = ParseErrorTranslate.translate(response!.error!);
      throw B4aException(
        errorTranslated,
        where: 'PatientRepositoryB4a.update',
        originalError: '${response.error!.code} -${response.error!.message}',
      );
    }
  }

  Future<void> updateRelationFamily(
      {required String objectId,
      required List<String> ids,
      required bool add}) async {
    final parseObject = PatientEntity()
        .toParseRelationFamily(objectId: objectId, ids: ids, add: add);
    if (parseObject != null) {
      await parseObject.save();
    }
  }

  Future<void> updateRelationHealthPlans(
      {required String objectId,
      required List<String> ids,
      required bool add}) async {
    final parseObject = PatientEntity()
        .toParseRelationHealthPlans(objectId: objectId, ids: ids, add: add);
    if (parseObject != null) {
      await parseObject.save();
    }
  }
}
