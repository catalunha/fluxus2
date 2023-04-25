import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/office_model.dart';

class OfficeEntity {
  static const String className = 'Office';
  static const String id = 'objectId';
  static const String name = 'name';

  static List<String> selectedCols(List<String> cols) {
    return cols.map((e) => '${OfficeEntity.className}.$e').toList();
  }

  static final List<String> singleCols = [
    OfficeEntity.name,
  ].map((e) => '${OfficeEntity.className}.$e').toList();

  static final List<String> pointerCols =
      [].map((e) => '${OfficeEntity.className}.$e').toList();

  static final List<String> relationCols =
      [].map((e) => '${OfficeEntity.className}.$e').toList();

  // static final List<String> allCols = [
  //   ...OfficeEntity.singleCols,
  //   ...OfficeEntity.pointerCols,
  //   ...OfficeEntity.relationCols
  // ];

  static List<String> filterSingleCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (OfficeEntity.singleCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${OfficeEntity.className}.', ''))
        .toList();
  }

  static List<String> filterPointerCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (OfficeEntity.pointerCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${OfficeEntity.className}.', ''))
        .toList();
  }

  static List<String> filterRelationCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (OfficeEntity.relationCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${OfficeEntity.className}.', ''))
        .toList();
  }

  OfficeModel toModel(ParseObject parseObject) {
    OfficeModel model = OfficeModel(
      id: parseObject.objectId!,
      name: parseObject.get(OfficeEntity.name),
    );
    return model;
  }

  Future<ParseObject> toParse(OfficeModel model) async {
    final parseObject = ParseObject(OfficeEntity.className);
    parseObject.objectId = model.id;

    if (model.name != null) {
      parseObject.set(OfficeEntity.name, model.name);
    }

    return parseObject;
  }
}
