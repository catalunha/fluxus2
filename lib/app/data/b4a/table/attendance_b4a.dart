import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/attendance_model.dart';
import '../../utils/pagination.dart';
import '../b4a_exception.dart';
import '../entity/attendance_entity.dart';
import '../utils/parse_error_translate.dart';

class AttendanceB4a {
  Future<QueryBuilder<ParseObject>> getQueryAll(
      QueryBuilder<ParseObject> query, Pagination pagination,
      [List<String> cols = const []]) async {
    query.setAmountToSkip((pagination.page - 1) * pagination.limit);
    query.setLimit(pagination.limit);
    print('AttendanceB4a.getQueryAll $cols');
    query.keysToReturn([
      ...AttendanceEntity.filterSingleCols(cols),
    ]);

    // query.keysToReturn([
    //   'professional',
    //   'procedure',
    //   'patient',
    //   'healthPlan',
    //   // 'healthPlan.healthPlanType',
    // ]);
    query.includeObject(AttendanceEntity.filterPointerCols(cols));
    // print(AttendanceEntity.filterPointerCols(cols));
    // query.includeObject([
    //   'professional',
    //   // 'professional.region',
    //   'procedure',
    //   // 'procedure.expertise',
    //   'patient',
    //   // 'patient.region',
    //   'healthPlan',
    //   'healthPlan.healthPlanType',
    //   // 'status',
    // ]);
    return query;
  }

  Future<AttendanceModel?> readById(String id,
      [List<String> cols = const []]) async {
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(AttendanceEntity.className));
    query.whereEqualTo(AttendanceEntity.id, id);
    query.keysToReturn([
      ...AttendanceEntity.filterSingleCols(cols),
    ]);
    query.includeObject(AttendanceEntity.filterPointerCols(cols));
    query.first();
    try {
      var response = await query.query();

      if (response.success && response.results != null) {
        return AttendanceEntity().toModel(response.results!.first, cols);
      }
      throw B4aException(
        'Perfil do usuário não encontrado.',
        where: 'AttendanceRepositoryB4a.readById()',
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<List<AttendanceModel>> list(
      QueryBuilder<ParseObject> query, Pagination pagination,
      [List<String> cols = const []]) async {
    QueryBuilder<ParseObject> query2;
    query2 = await getQueryAll(query, pagination, cols);
    ParseResponse? parseResponse;
    try {
      parseResponse = await query2.query();
      List<AttendanceModel> listTemp = <AttendanceModel>[];
      if (parseResponse.success && parseResponse.results != null) {
        for (var element in parseResponse.results!) {
          listTemp.add(await AttendanceEntity().toModel(element, cols));
        }
        return listTemp;
      } else {
        return [];
      }
    } on Exception {
      var errorTranslated =
          ParseErrorTranslate.translate(parseResponse!.error!);
      throw B4aException(
        errorTranslated,
        where: 'AttendanceRepositoryB4a.list',
        originalError:
            '${parseResponse.error!.code} -${parseResponse.error!.message}',
      );
    }
  }

  Future<String> update(AttendanceModel model) async {
    final parseObject = await AttendanceEntity().toParse(model);
    ParseResponse? parseResponse;
    try {
      parseResponse = await parseObject.save();

      if (parseResponse.success && parseResponse.results != null) {
        ParseObject parseObjectItem =
            parseResponse.results!.first as ParseObject;
        return parseObjectItem.objectId!;
      } else {
        throw Exception();
      }
    } on Exception {
      var errorTranslated =
          ParseErrorTranslate.translate(parseResponse!.error!);
      throw B4aException(
        errorTranslated,
        where: 'AttendanceRepositoryB4a.update',
        originalError:
            '${parseResponse.error!.code} -${parseResponse.error!.message}',
      );
    }
  }

  Future<bool> delete(String modelId) async {
    final parseObject = ParseObject(AttendanceEntity.className);
    parseObject.objectId = modelId;
    ParseResponse? parseResponse;

    try {
      parseResponse = await parseObject.delete();
      if (parseResponse.success && parseResponse.results != null) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      var errorTranslated =
          ParseErrorTranslate.translate(parseResponse!.error!);
      throw B4aException(
        errorTranslated,
        where: 'AttendanceRepositoryB4a.delete',
        originalError:
            '${parseResponse.error!.code} -${parseResponse.error!.message}',
      );
    }
  }
}
