import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'expertise_model.dart';
import 'office_model.dart';
import 'procedure_model.dart';
import 'region_model.dart';

// Perfil de usuario
class UserProfileModel {
  final String id;
  final String email;
  final bool isActive;
  final List<String> access; //admin, sec, prof, fin

  final String? nickname;
  final String? name;
  final String? cpf;
  final String? register; // conselho de saude
  final String? phone;
  final String? photo;
  final bool? isFemale;
  final DateTime? birthday;
  final String? address;
  final RegionModel? region;
  final List<OfficeModel>? offices; // cargos
  final List<ExpertiseModel>? expertises; // especialidade
  final List<ProcedureModel>? procedures; // procedimentos
  UserProfileModel({
    required this.id,
    required this.email,
    required this.isActive,
    required this.access,
    this.nickname,
    this.name,
    this.cpf,
    this.register,
    this.phone,
    this.photo,
    this.isFemale,
    this.birthday,
    this.address,
    this.region,
    this.offices,
    this.expertises,
    this.procedures,
  });

  UserProfileModel copyWith({
    String? id,
    String? email,
    bool? isActive,
    List<String>? access,
    String? nickname,
    String? name,
    String? cpf,
    String? register,
    String? phone,
    String? photo,
    bool? isFemale,
    DateTime? birthday,
    String? address,
    RegionModel? region,
    List<OfficeModel>? offices,
    List<ExpertiseModel>? expertises,
    List<ProcedureModel>? procedures,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      access: access ?? this.access,
      nickname: nickname ?? this.nickname,
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      register: register ?? this.register,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      isFemale: isFemale ?? this.isFemale,
      birthday: birthday ?? this.birthday,
      address: address ?? this.address,
      region: region ?? this.region,
      offices: offices ?? this.offices,
      expertises: expertises ?? this.expertises,
      procedures: procedures ?? this.procedures,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileModel &&
        other.id == id &&
        other.email == email &&
        other.isActive == isActive &&
        listEquals(other.access, access) &&
        other.nickname == nickname &&
        other.name == name &&
        other.cpf == cpf &&
        other.register == register &&
        other.phone == phone &&
        other.photo == photo &&
        other.isFemale == isFemale &&
        other.birthday == birthday &&
        other.address == address &&
        other.region == region &&
        listEquals(other.offices, offices) &&
        listEquals(other.expertises, expertises) &&
        listEquals(other.procedures, procedures);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        isActive.hashCode ^
        access.hashCode ^
        nickname.hashCode ^
        name.hashCode ^
        cpf.hashCode ^
        register.hashCode ^
        phone.hashCode ^
        photo.hashCode ^
        isFemale.hashCode ^
        birthday.hashCode ^
        address.hashCode ^
        region.hashCode ^
        offices.hashCode ^
        expertises.hashCode ^
        procedures.hashCode;
  }

  @override
  String toString() {
    return 'UserProfileModel(id: $id, email: $email, isActive: $isActive, access: $access, nickname: $nickname, name: $name, cpf: $cpf, register: $register, phone: $phone, photo: $photo, isFemale: $isFemale, birthday: $birthday, address: $address, region: $region, offices: $offices, expertises: $expertises, procedures: $procedures)';
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'email': email});
    result.addAll({'isActive': isActive});
    result.addAll({'access': access});
    if (nickname != null) {
      result.addAll({'nickname': nickname});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (cpf != null) {
      result.addAll({'cpf': cpf});
    }
    if (register != null) {
      result.addAll({'register': register});
    }
    if (phone != null) {
      result.addAll({'phone': phone});
    }
    if (photo != null) {
      result.addAll({'photo': photo});
    }
    if (isFemale != null) {
      result.addAll({'isFemale': isFemale});
    }
    if (birthday != null) {
      result.addAll({'birthday': birthday!.millisecondsSinceEpoch});
    }
    if (address != null) {
      result.addAll({'address': address});
    }
    if (region != null) {
      result.addAll({'region': region!.toMap()});
    }
    if (offices != null) {
      result.addAll({'offices': offices!.map((x) => x.toMap()).toList()});
    }
    if (expertises != null) {
      result.addAll({'expertises': expertises!.map((x) => x.toMap()).toList()});
    }
    if (procedures != null) {
      result.addAll({'procedures': procedures!.map((x) => x.toMap()).toList()});
    }

    return result;
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      isActive: map['isActive'] ?? false,
      access: List<String>.from(map['access']),
      nickname: map['nickname'],
      name: map['name'],
      cpf: map['cpf'],
      register: map['register'],
      phone: map['phone'],
      photo: map['photo'],
      isFemale: map['isFemale'],
      birthday: map['birthday'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['birthday'])
          : null,
      address: map['address'],
      region: map['region'] != null ? RegionModel.fromMap(map['region']) : null,
      offices: map['offices'] != null
          ? List<OfficeModel>.from(
              map['offices']?.map((x) => OfficeModel.fromMap(x)))
          : null,
      expertises: map['expertises'] != null
          ? List<ExpertiseModel>.from(
              map['expertises']?.map((x) => ExpertiseModel.fromMap(x)))
          : null,
      procedures: map['procedures'] != null
          ? List<ProcedureModel>.from(
              map['procedures']?.map((x) => ProcedureModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfileModel.fromJson(String source) =>
      UserProfileModel.fromMap(json.decode(source));
}
