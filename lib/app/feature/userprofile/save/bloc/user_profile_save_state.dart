import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/models/graduation_model.dart';
import '../../../../core/models/user_model.dart';

enum UserProfileSaveStateStatus { initial, loading, success, error }

class UserProfileSaveState {
  final UserProfileSaveStateStatus status;
  final String? error;
  final UserModel user;
  final XFile? xfile;
  final List<GraduationModel> graduationsOriginal;
  final List<GraduationModel> graduationsUpdated;
  UserProfileSaveState({
    required this.status,
    this.error,
    required this.user,
    this.xfile,
    this.graduationsOriginal = const [],
    this.graduationsUpdated = const [],
  });

  UserProfileSaveState.initial(this.user)
      : status = UserProfileSaveStateStatus.initial,
        error = '',
        xfile = null,
        graduationsOriginal = user.userProfile?.graduations ?? [],
        graduationsUpdated = user.userProfile?.graduations ?? [];

  UserProfileSaveState copyWith({
    UserProfileSaveStateStatus? status,
    String? error,
    UserModel? user,
    XFile? xfile,
    List<GraduationModel>? graduationsOriginal,
    List<GraduationModel>? graduationsUpdated,
  }) {
    return UserProfileSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
      xfile: xfile ?? this.xfile,
      graduationsOriginal: graduationsOriginal ?? this.graduationsOriginal,
      graduationsUpdated: graduationsUpdated ?? this.graduationsUpdated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileSaveState &&
        other.status == status &&
        other.error == error &&
        other.user == user &&
        other.xfile == xfile &&
        listEquals(other.graduationsOriginal, graduationsOriginal) &&
        listEquals(other.graduationsUpdated, graduationsUpdated);
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        user.hashCode ^
        xfile.hashCode ^
        graduationsOriginal.hashCode ^
        graduationsUpdated.hashCode;
  }

  @override
  String toString() {
    return 'UserProfileSaveState(status: $status, error: $error, user: $user, xfile: $xfile, graduationsOriginal: $graduationsOriginal, graduationsUpdated: $graduationsUpdated)';
  }
}
