import 'dart:convert';

/// Especialidade
class ExpertiseModel {
  final String? id;
  final String? name;
  final String? description;

  ExpertiseModel({
    this.id,
    this.name,
    this.description,
  });

  ExpertiseModel copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return ExpertiseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
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
    if (description != null) {
      result.addAll({'description': description});
    }

    return result;
  }

  factory ExpertiseModel.fromMap(Map<String, dynamic> map) {
    return ExpertiseModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpertiseModel.fromJson(String source) =>
      ExpertiseModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ExpertiseModel(id: $id, name: $name, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpertiseModel &&
        other.id == id &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;
}
