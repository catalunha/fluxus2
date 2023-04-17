import 'dart:convert';

/// Graduação
class OfficeModel {
  final String? id;
  final String? name;

  OfficeModel({
    this.id,
    this.name,
  });

  OfficeModel copyWith({
    String? id,
    String? name,
  }) {
    return OfficeModel(
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

  factory OfficeModel.fromMap(Map<String, dynamic> map) {
    return OfficeModel(
      id: map['id'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OfficeModel.fromJson(String source) =>
      OfficeModel.fromMap(json.decode(source));

  @override
  String toString() => 'OfficeModel(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OfficeModel && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
