import 'dart:convert';

import 'healthplantype_model.dart';

class HealthPlanModel {
  final String? id;
  final HealthPlanTypeModel? healthPlanType;
  final String? code;
  final DateTime? due;
  final String? description;
  HealthPlanModel({
    this.id,
    this.healthPlanType,
    this.code,
    this.due,
    this.description,
  });

  HealthPlanModel copyWith({
    String? id,
    HealthPlanTypeModel? healthPlanType,
    String? code,
    DateTime? due,
    String? description,
  }) {
    return HealthPlanModel(
      id: id ?? this.id,
      healthPlanType: healthPlanType ?? this.healthPlanType,
      code: code ?? this.code,
      due: due ?? this.due,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (healthPlanType != null) {
      result.addAll({'healthPlanType': healthPlanType!.toMap()});
    }
    if (code != null) {
      result.addAll({'code': code});
    }
    if (due != null) {
      result.addAll({'due': due!.millisecondsSinceEpoch});
    }
    if (description != null) {
      result.addAll({'description': description});
    }

    return result;
  }

  factory HealthPlanModel.fromMap(Map<String, dynamic> map) {
    return HealthPlanModel(
      id: map['id'],
      healthPlanType: map['healthPlanType'] != null
          ? HealthPlanTypeModel.fromMap(map['healthPlanType'])
          : null,
      code: map['code'],
      due: map['due'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['due'])
          : null,
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HealthPlanModel.fromJson(String source) =>
      HealthPlanModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HealthPlanModel(id: $id, healthPlanType: $healthPlanType, code: $code, due: $due, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HealthPlanModel &&
        other.id == id &&
        other.healthPlanType == healthPlanType &&
        other.code == code &&
        other.due == due &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        healthPlanType.hashCode ^
        code.hashCode ^
        due.hashCode ^
        description.hashCode;
  }
}
