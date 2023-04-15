import 'dart:convert';

/// Tipo do plano de saude: Unimed, Prefeitura, Particular, etc
class HealthPlanTypeModel {
  final String? id;
  final String? name;

  HealthPlanTypeModel({
    this.id,
    this.name,
  });

  HealthPlanTypeModel copyWith({
    String? id,
    String? name,
  }) {
    return HealthPlanTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (name != null) {
      result.addAll({'name': name});
    }

    return result;
  }

  factory HealthPlanTypeModel.fromMap(Map<String, dynamic> map) {
    return HealthPlanTypeModel(
      id: map['id'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HealthPlanTypeModel.fromJson(String source) =>
      HealthPlanTypeModel.fromMap(json.decode(source));

  @override
  String toString() => 'HealthPlanTypeModel(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HealthPlanTypeModel && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
