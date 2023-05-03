import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/expertise_model.dart';

class ExpertiseEntity {
  static const String className = 'Expertise';
  static const String id = 'objectId';
  static const String name = 'name';

  static List<String> selectedCols(List<String> cols) {
    return cols.map((e) => '${ExpertiseEntity.className}.$e').toList();
  }

  static final List<String> singleCols = [
    ExpertiseEntity.name,
  ].map((e) => '${ExpertiseEntity.className}.$e').toList();

  static final List<String> pointerCols =
      [].map((e) => '${ExpertiseEntity.className}.$e').toList();

  static final List<String> relationCols =
      [].map((e) => '${ExpertiseEntity.className}.$e').toList();

  static List<String> filterSingleCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (ExpertiseEntity.singleCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${ExpertiseEntity.className}.', ''))
        .toList();
  }

  static List<String> filterPointerCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (ExpertiseEntity.pointerCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${ExpertiseEntity.className}.', ''))
        .toList();
  }

  static List<String> filterRelationCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (ExpertiseEntity.relationCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${ExpertiseEntity.className}.', ''))
        .toList();
  }

  ExpertiseModel toModel(ParseObject parseObject,
      [List<String> cols = const []]) {
    ExpertiseModel model = ExpertiseModel(
      id: parseObject.objectId!,
      name: parseObject.get(ExpertiseEntity.name),
    );
    return model;
  }

  Future<ParseObject> toParse(ExpertiseModel model) async {
    final parseObject = ParseObject(ExpertiseEntity.className);
    parseObject.objectId = model.id;

    if (model.name != null) {
      parseObject.set(ExpertiseEntity.name, model.name);
    }

    return parseObject;
  }
}
