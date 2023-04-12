import 'package:flutter/foundation.dart';

import '../../../../core/models/user_profile_model.dart';

enum UserProfileAccessStateStatus { initial, loading, success, error }

class UserProfileAccessState {
  final UserProfileAccessStateStatus status;
  final String? error;
  final List<String> access;
  final UserProfileModel userProfileModel;
  UserProfileAccessState({
    required this.status,
    this.error,
    required this.access,
    required this.userProfileModel,
  });
  UserProfileAccessState.initial(this.userProfileModel)
      : status = UserProfileAccessStateStatus.initial,
        error = '',
        access = userProfileModel.access ?? [];

  UserProfileAccessState copyWith({
    UserProfileAccessStateStatus? status,
    String? error,
    List<String>? access,
    UserProfileModel? userProfileModel,
  }) {
    return UserProfileAccessState(
      status: status ?? this.status,
      error: error ?? this.error,
      access: access ?? this.access,
      userProfileModel: userProfileModel ?? this.userProfileModel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileAccessState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.access, access) &&
        other.userProfileModel == userProfileModel;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        access.hashCode ^
        userProfileModel.hashCode;
  }
}
