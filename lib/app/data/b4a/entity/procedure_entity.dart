import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/procedure_model.dart';
import 'expertise_entity.dart';

class ProcedureEntity {
  static const String className = 'Procedure';
  // Nome do campo local =  no Database
  static const String id = 'objectId';
  static const String code = 'code';
  static const String name = 'name';
  static const String cost = 'cost';
  static const String expertise = 'expertise';

  static List<String> selectedCols(List<String> cols) {
    return cols.map((e) => '${ProcedureEntity.className}.$e').toList();
  }

  static final List<String> singleCols = [
    ProcedureEntity.code,
    ProcedureEntity.name,
    ProcedureEntity.cost,
    ProcedureEntity.expertise,
  ].map((e) => '${ProcedureEntity.className}.$e').toList();

  static final List<String> pointerCols = [
    ProcedureEntity.expertise,
  ].map((e) => '${ProcedureEntity.className}.$e').toList();

  static final List<String> relationCols =
      [].map((e) => '${ProcedureEntity.className}.$e').toList();

  // static final List<String> allCols = [
  //   ...ProcedureEntity.singleCols,
  //   ...ProcedureEntity.pointerCols,
  //   ...ProcedureEntity.relationCols
  // ];

  static List<String> filterSingleCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (ProcedureEntity.singleCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${ProcedureEntity.className}.', ''))
        .toList();
  }

  static List<String> filterPointerCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (ProcedureEntity.pointerCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${ProcedureEntity.className}.', ''))
        .toList();
  }

  static List<String> filterRelationCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (ProcedureEntity.relationCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${ProcedureEntity.className}.', ''))
        .toList();
  }

  ProcedureModel toModel(ParseObject parseObject) {
    ProcedureModel model = ProcedureModel(
      id: parseObject.objectId!,
      code: parseObject.get(ProcedureEntity.code),
      name: parseObject.get(ProcedureEntity.name),
      cost: parseObject.get(ProcedureEntity.cost)?.toDouble(),
      expertise: parseObject.get(ProcedureEntity.expertise) != null
          ? ExpertiseEntity()
              .toModel(parseObject.get(ProcedureEntity.expertise))
          : null,
    );
    return model;
  }

  Future<ParseObject> toParse(ProcedureModel model) async {
    final parseObject = ParseObject(ProcedureEntity.className);
    parseObject.objectId = model.id;
    if (model.name != null) {
      parseObject.set(ProcedureEntity.name, model.name);
    }
    if (model.code != null) {
      parseObject.set(ProcedureEntity.code, model.code);
    }
    if (model.cost != null) {
      parseObject.set(ProcedureEntity.cost, model.cost);
    }

    if (model.expertise != null) {
      parseObject.set(
          ProcedureEntity.expertise,
          (ParseObject(ExpertiseEntity.className)
                ..objectId = model.expertise!.id)
              .toPointer());
    }
    return parseObject;
  }
}
