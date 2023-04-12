import 'dart:convert';

/// Graduação
class GraduationModel {
  final String? id;
  final String? name;
  final String? description;

  GraduationModel({
    this.id,
    this.name,
    this.description,
  });

  GraduationModel copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return GraduationModel(
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

  factory GraduationModel.fromMap(Map<String, dynamic> map) {
    return GraduationModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GraduationModel.fromJson(String source) =>
      GraduationModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'GraduationModel(id: $id, name: $name, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GraduationModel &&
        other.id == id &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;
}
