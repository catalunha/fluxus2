import 'dart:convert';

/// Especialidade
class ExpertiseModel {
  final String? id;
  final String? name;

  ExpertiseModel({
    this.id,
    this.name,
  });

  ExpertiseModel copyWith({
    String? id,
    String? name,
  }) {
    return ExpertiseModel(
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

  factory ExpertiseModel.fromMap(Map<String, dynamic> map) {
    return ExpertiseModel(
      id: map['id'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpertiseModel.fromJson(String source) =>
      ExpertiseModel.fromMap(json.decode(source));

  @override
  String toString() => 'ExpertiseModel(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpertiseModel && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
