part of 'user_profile_edit_bloc.dart';

enum UserProfileEditStateStatus { initial, loading, success, error }

class UserProfileEditState {
  final UserProfileEditStateStatus status;
  final String? error;
  final UserModel user;
  final XFile? xfile;
  UserProfileEditState({
    required this.status,
    this.error,
    required this.user,
    this.xfile,
  });

  UserProfileEditState.initial(this.user)
      : status = UserProfileEditStateStatus.initial,
        error = '',
        xfile = null;

  UserProfileEditState copyWith({
    UserProfileEditStateStatus? status,
    String? error,
    UserModel? user,
    XFile? xfile,
  }) {
    return UserProfileEditState(
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
      xfile: xfile ?? this.xfile,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileEditState &&
        other.status == status &&
        other.error == error &&
        other.user == user &&
        other.xfile == xfile;
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ user.hashCode ^ xfile.hashCode;
  }
}
