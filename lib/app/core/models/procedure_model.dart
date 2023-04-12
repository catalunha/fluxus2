import 'dart:convert';

import 'expertise_model.dart';

class ProcedureModel {
  final String? id;
  final ExpertiseModel? expertise;
  final String? code;
  final String? name;
  final double? cost;
  ProcedureModel({
    this.id,
    this.expertise,
    this.code,
    this.name,
    this.cost,
  });

  ProcedureModel copyWith({
    String? id,
    ExpertiseModel? expertise,
    String? code,
    String? name,
    double? cost,
  }) {
    return ProcedureModel(
      id: id ?? this.id,
      expertise: expertise ?? this.expertise,
      code: code ?? this.code,
      name: name ?? this.name,
      cost: cost ?? this.cost,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (expertise != null) {
      result.addAll({'expertise': expertise!.toMap()});
    }
    if (code != null) {
      result.addAll({'code': code});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (cost != null) {
      result.addAll({'cost': cost});
    }

    return result;
  }

  factory ProcedureModel.fromMap(Map<String, dynamic> map) {
    return ProcedureModel(
      id: map['id'],
      expertise: map['expertise'] != null
          ? ExpertiseModel.fromMap(map['expertise'])
          : null,
      code: map['code'],
      name: map['name'],
      cost: map['cost']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProcedureModel.fromJson(String source) =>
      ProcedureModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProcedureModel(id: $id, expertise: $expertise, code: $code, name: $name, cost: $cost)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProcedureModel &&
        other.id == id &&
        other.expertise == expertise &&
        other.code == code &&
        other.name == name &&
        other.cost == cost;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        expertise.hashCode ^
        code.hashCode ^
        name.hashCode ^
        cost.hashCode;
  }
}
