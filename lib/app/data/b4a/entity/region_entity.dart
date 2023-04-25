import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/region_model.dart';

class RegionEntity {
  static const String className = 'Region';
  // Nome do campo local =  no Database
  static const String id = 'objectId';
  static const String uf = 'uf';
  static const String city = 'city';
  static const String name = 'name';
  static final List<String> singleCols = [
    RegionEntity.uf,
    RegionEntity.city,
    RegionEntity.name,
  ].map((e) => '${RegionEntity.className}.$e').toList();
  static final List<String> pointerCols =
      [].map((e) => '${RegionEntity.className}.$e').toList();
  static final List<String> relationCols =
      [].map((e) => '${RegionEntity.className}.$e').toList();
  // static final List<String> allCols = [
  //   ...RegionEntity.singleCols,
  //   ...RegionEntity.pointerCols,
  //   ...RegionEntity.relationCols
  // ];
  static List<String> filterSingleCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (RegionEntity.singleCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${RegionEntity.className}.', ''))
        .toList();
  }

  static List<String> filterPointerCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (RegionEntity.pointerCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp;
  }

  static List<String> filterRelationCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (RegionEntity.relationCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp;
  }

  RegionModel toModel(ParseObject parseObject, [List<String> cols = const []]) {
    RegionModel model = RegionModel(
        id: parseObject.objectId!,
        uf: parseObject.get(RegionEntity.uf),
        city: parseObject.get(RegionEntity.city),
        name: parseObject.get(RegionEntity.name)
        // name: RegionEntity.relationCols.contains(RegionEntity.name)
        //     ? parseObject.get(RegionEntity.name)
        //     : null,
        );
    return model;
  }

  Future<ParseObject> toParse(RegionModel model) async {
    final parseObject = ParseObject(RegionEntity.className);
    parseObject.objectId = model.id;

    if (model.uf != null) {
      parseObject.set(RegionEntity.uf, model.uf);
    }
    if (model.city != null) {
      parseObject.set(RegionEntity.city, model.city);
    }
    if (model.name != null) {
      parseObject.set(RegionEntity.name, model.name);
    }

    return parseObject;
  }
}
