import 'dart:convert';

class EventModel {
  final String? id;
  EventModel({
    this.id,
  });

  EventModel copyWith({
    String? id,
  }) {
    return EventModel(
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

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));

  @override
  String toString() => 'EventModel(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
