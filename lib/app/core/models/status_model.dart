import 'dart:convert';

/// Status em geral.
class StatusModel {
  final String? id;
  final String? name;
  final String? description;

  StatusModel({
    this.id,
    this.name,
    this.description,
  });

  StatusModel copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return StatusModel(
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

  factory StatusModel.fromMap(Map<String, dynamic> map) {
    return StatusModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StatusModel.fromJson(String source) =>
      StatusModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'StatusModel(id: $id, name: $name, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StatusModel &&
        other.id == id &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;
}
