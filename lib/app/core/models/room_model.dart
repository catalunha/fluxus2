import 'dart:convert';

/// Sala de atendimento
class RoomModel {
  final String? id;
  final String? name;
  final bool? isActive;

  RoomModel({
    this.id,
    this.name,
    this.isActive,
  });

  RoomModel copyWith({
    String? id,
    String? name,
    bool? isActive,
  }) {
    return RoomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
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
    if (isActive != null) {
      result.addAll({'isActive': isActive});
    }

    return result;
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'],
      name: map['name'],
      isActive: map['isActive'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) =>
      RoomModel.fromMap(json.decode(source));

  @override
  String toString() => 'RoomModel(id: $id, name: $name, isActive: $isActive)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoomModel &&
        other.id == id &&
        other.name == name &&
        other.isActive == isActive;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ isActive.hashCode;
}
