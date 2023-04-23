import 'package:image_picker/image_picker.dart';

import '../../../../core/models/region_model.dart';
import '../../../../core/models/user_model.dart';

enum UserProfileSaveStateStatus { initial, updated, loading, success, error }

class UserProfileSaveState {
  final UserProfileSaveStateStatus status;
  final String? error;
  final UserModel user;
  final XFile? xfile;
  final RegionModel? region;

  UserProfileSaveState({
    required this.status,
    this.error,
    required this.user,
    this.xfile,
    this.region,
  });

  UserProfileSaveState.initial(this.user)
      : status = UserProfileSaveStateStatus.initial,
        error = '',
        xfile = null,
        region = user.userProfile?.region;

  UserProfileSaveState copyWith({
    UserProfileSaveStateStatus? status,
    String? error,
    UserModel? user,
    XFile? xfile,
    RegionModel? region,
  }) {
    return UserProfileSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
      xfile: xfile ?? this.xfile,
      region: region ?? this.region,
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
        other.region == region;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        user.hashCode ^
        xfile.hashCode ^
        region.hashCode;
  }

  @override
  String toString() {
    return 'UserProfileSaveState(status: $status, error: $error, user: $user, xfile: $xfile, region: $region)';
  }
}
