import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'healthplan_model.dart';
import 'region_model.dart';

// Paciente
class PatientModel {
  final String? id;
  final String? email;
  final String? phone;
  final String? nickname;
  final String? name;
  final String? cpf;
  final bool? isFemale;
  final DateTime? birthday;
  final String? address;
  final RegionModel? region;
  final List<PatientModel>? family;
  final List<HealthPlanModel>? healthPlans;
  PatientModel({
    this.id,
    this.email,
    this.phone,
    this.nickname,
    this.name,
    this.cpf,
    this.isFemale,
    this.birthday,
    this.address,
    this.region,
    this.family,
    this.healthPlans,
  });

  PatientModel copyWith({
    String? id,
    String? email,
    String? phone,
    String? nickname,
    String? name,
    String? cpf,
    bool? isFemale,
    DateTime? birthday,
    String? address,
    RegionModel? region,
    List<PatientModel>? family,
    List<HealthPlanModel>? healthPlans,
  }) {
    return PatientModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      nickname: nickname ?? this.nickname,
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      isFemale: isFemale ?? this.isFemale,
      birthday: birthday ?? this.birthday,
      address: address ?? this.address,
      region: region ?? this.region,
      family: family ?? this.family,
      healthPlans: healthPlans ?? this.healthPlans,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (phone != null) {
      result.addAll({'phone': phone});
    }
    if (nickname != null) {
      result.addAll({'nickname': nickname});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (cpf != null) {
      result.addAll({'cpf': cpf});
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
    if (family != null) {
      result.addAll({'family': family!.map((x) => x.toMap()).toList()});
    }
    if (healthPlans != null) {
      result
          .addAll({'healthPlans': healthPlans!.map((x) => x.toMap()).toList()});
    }

    return result;
  }

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      id: map['id'],
      email: map['email'],
      phone: map['phone'],
      nickname: map['nickname'],
      name: map['name'],
      cpf: map['cpf'],
      isFemale: map['isFemale'],
      birthday: map['birthday'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['birthday'])
          : null,
      address: map['address'],
      region: map['region'] != null ? RegionModel.fromMap(map['region']) : null,
      family: map['family'] != null
          ? List<PatientModel>.from(
              map['family']?.map((x) => PatientModel.fromMap(x)))
          : null,
      healthPlans: map['healthPlans'] != null
          ? List<HealthPlanModel>.from(
              map['healthPlans']?.map((x) => HealthPlanModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PatientModel.fromJson(String source) =>
      PatientModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PatientModel(id: $id, email: $email, phone: $phone, nickname: $nickname, name: $name, cpf: $cpf, isFemale: $isFemale, birthday: $birthday, address: $address, region: $region, family: $family, healthPlans: $healthPlans)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PatientModel &&
        other.id == id &&
        other.email == email &&
        other.phone == phone &&
        other.nickname == nickname &&
        other.name == name &&
        other.cpf == cpf &&
        other.isFemale == isFemale &&
        other.birthday == birthday &&
        other.address == address &&
        other.region == region &&
        listEquals(other.family, family) &&
        listEquals(other.healthPlans, healthPlans);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        nickname.hashCode ^
        name.hashCode ^
        cpf.hashCode ^
        isFemale.hashCode ^
        birthday.hashCode ^
        address.hashCode ^
        region.hashCode ^
        family.hashCode ^
        healthPlans.hashCode;
  }
}
