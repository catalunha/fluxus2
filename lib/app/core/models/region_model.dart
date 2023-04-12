import 'dart:convert';

class RegionModel {
  final String? id;
  final String? uf;
  final String? city;
  final String? name;
  RegionModel({
    this.id,
    this.uf,
    this.city,
    this.name,
  });

  RegionModel copyWith({
    String? id,
    String? uf,
    String? city,
    String? name,
  }) {
    return RegionModel(
      id: id ?? this.id,
      uf: uf ?? this.uf,
      city: city ?? this.city,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (uf != null) {
      result.addAll({'uf': uf});
    }
    if (city != null) {
      result.addAll({'city': city});
    }
    if (name != null) {
      result.addAll({'name': name});
    }

    return result;
  }

  factory RegionModel.fromMap(Map<String, dynamic> map) {
    return RegionModel(
      id: map['id'],
      uf: map['uf'],
      city: map['city'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RegionModel.fromJson(String source) =>
      RegionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RegionModel(id: $id, uf: $uf, city: $city, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegionModel &&
        other.id == id &&
        other.uf == uf &&
        other.city == city &&
        other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uf.hashCode ^ city.hashCode ^ name.hashCode;
  }
}
