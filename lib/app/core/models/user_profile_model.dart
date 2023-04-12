import 'dart:convert';

import 'package:flutter/foundation.dart';

// Perfil de usuario
class UserProfileModel {
  final String id;
  final String email;
  final String? name;
  final String? cpf;
  final String? phone;
  final String? photo;
  final List<String>? access; //admin, seller
  final bool isActive;

  UserProfileModel({
    required this.id,
    required this.email,
    this.name,
    this.cpf,
    this.phone,
    this.photo,
    this.access,
    required this.isActive,
  });

  UserProfileModel copyWith({
    String? id,
    String? email,
    String? name,
    String? cpf,
    String? phone,
    String? photo,
    List<String>? access,
    bool? isActive,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      access: access ?? this.access,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'email': email});
    if (name != null) {
      result.addAll({'name': name});
    }
    if (cpf != null) {
      result.addAll({'cpf': cpf});
    }
    if (phone != null) {
      result.addAll({'phone': phone});
    }
    if (photo != null) {
      result.addAll({'photo': photo});
    }
    if (access != null) {
      result.addAll({'access': access});
    }
    result.addAll({'isActive': isActive});

    return result;
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'],
      cpf: map['cpf'],
      phone: map['phone'],
      photo: map['photo'],
      access: List<String>.from(map['access']),
      isActive: map['isActive'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfileModel.fromJson(String source) =>
      UserProfileModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProfileModel(id: $id, email: $email, name: $name, cpf: $cpf, phone: $phone, photo: $photo, access: $access, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileModel &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.cpf == cpf &&
        other.phone == phone &&
        other.photo == photo &&
        listEquals(other.access, access) &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        cpf.hashCode ^
        phone.hashCode ^
        photo.hashCode ^
        access.hashCode ^
        isActive.hashCode;
  }
}
