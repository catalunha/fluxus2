import 'dart:convert';

class EvolutionModel {
  final String? id;
  EvolutionModel({
    this.id,
  });

  EvolutionModel copyWith({
    String? id,
  }) {
    return EvolutionModel(
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }

    return result;
  }

  factory EvolutionModel.fromMap(Map<String, dynamic> map) {
    return EvolutionModel(
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EvolutionModel.fromJson(String source) =>
      EvolutionModel.fromMap(json.decode(source));

  @override
  String toString() => 'EvolutionModel(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EvolutionModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
