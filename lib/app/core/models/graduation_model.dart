import 'dart:convert';

/// Graduação
class GraduationModel {
  final String? id;
  final String? name;

  GraduationModel({
    this.id,
    this.name,
  });

  GraduationModel copyWith({
    String? id,
    String? name,
  }) {
    return GraduationModel(
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

  factory GraduationModel.fromMap(Map<String, dynamic> map) {
    return GraduationModel(
      id: map['id'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GraduationModel.fromJson(String source) =>
      GraduationModel.fromMap(json.decode(source));

  @override
  String toString() => 'GraduationModel(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GraduationModel && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
