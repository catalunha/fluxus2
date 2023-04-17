import 'dart:convert';

class InvoiceModel {
  final String? id;
  InvoiceModel({
    this.id,
  });

  InvoiceModel copyWith({
    String? id,
  }) {
    return InvoiceModel(
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

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    return InvoiceModel(
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory InvoiceModel.fromJson(String source) =>
      InvoiceModel.fromMap(json.decode(source));

  @override
  String toString() => 'InvoiceModel(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InvoiceModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
