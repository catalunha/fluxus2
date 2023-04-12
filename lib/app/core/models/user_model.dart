import 'dart:convert';

import 'user_profile_model.dart';

class UserModel {
  final String id;
  final String email;
  UserProfileModel? userProfile;
  UserModel({
    required this.id,
    required this.email,
    this.userProfile,
  });

  UserModel copyWith({
    String? id,
    String? email,
    UserProfileModel? userProfile,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      userProfile: userProfile ?? this.userProfile,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'email': email});
    if (userProfile != null) {
      result.addAll({'userProfile': userProfile!.toMap()});
    }

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      userProfile: map['userProfile'] != null
          ? UserProfileModel.fromMap(map['userProfile'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserModel(id: $id, email: $email, userProfile: $userProfile)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.userProfile == userProfile;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ userProfile.hashCode;
}
