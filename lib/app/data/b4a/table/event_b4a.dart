import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/event_model.dart';
import '../../utils/pagination.dart';
import '../b4a_exception.dart';
import '../entity/event_entity.dart';
import '../utils/parse_error_translate.dart';

class EventB4a {
  Future<QueryBuilder<ParseObject>> getQueryAll(
      QueryBuilder<ParseObject> query, Pagination pagination,
      [List<String> cols = const []]) async {
    query.setAmountToSkip((pagination.page - 1) * pagination.limit);
    query.setLimit(pagination.limit);
    query.keysToReturn([
      ...EventEntity.filterSingleCols(cols),
    ]);
    query.includeObject(EventEntity.filterPointerCols(cols));

    // query.includeObject([
    //   'room',
    //   'status',
    // ]);
    return query;
  }

  Future<List<EventModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination, [
    List<String> cols = const [],
  ]) async {
    QueryBuilder<ParseObject> query2;
    query2 = await getQueryAll(query, pagination, cols);
    ParseResponse? response;
    try {
      response = await query2.query();
      List<EventModel> listTemp = <EventModel>[];
      if (response.success && response.results != null) {
        for (var element in response.results!) {
          listTemp.add(await EventEntity().toModel(element, cols));
        }
        return listTemp;
      } else {
        return [];
      }
    } on Exception {
      var errorTranslated = ParseErrorTranslate.translate(response!.error!);
      throw B4aException(
        errorTranslated,
        where: 'EventRepositoryB4a.list',
        originalError: '${response.error!.code} -${response.error!.message}',
      );
    }
  }

  Future<EventModel?> readById(String id,
      [List<String> cols = const []]) async {
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(EventEntity.className));
    query.whereEqualTo(EventEntity.id, id);
    query.keysToReturn([
      ...EventEntity.filterSingleCols(cols),
    ]);
    query.includeObject(EventEntity.filterPointerCols(cols));
    // query.includeObject(['region']);
    query.first();
    try {
      var response = await query.query();

      if (response.success && response.results != null) {
        return EventEntity().toModel(response.results!.first, cols);
      }
      throw B4aException(
        'Perfil do usuário não encontrado.',
        where: 'EventRepositoryB4a.readById()',
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<String> update(EventModel userProfileModel) async {
    final userProfileParse = await EventEntity().toParse(userProfileModel);
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
        where: 'EventRepositoryB4a.update',
        originalError: '${response.error!.code} -${response.error!.message}',
      );
    }
  }

  Future<void> updateRelationAttendances(
      {required String objectId,
      required List<String> ids,
      required bool add}) async {
    final parseObject = EventEntity()
        .toParseRelationAttendances(objectId: objectId, ids: ids, add: add);
    if (parseObject != null) {
      await parseObject.save();
    }
  }
}
