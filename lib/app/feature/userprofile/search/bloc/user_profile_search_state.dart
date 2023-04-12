import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/user_profile_model.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';

enum UserProfileSearchStateStatus { initial, loading, success, error }

class UserProfileSearchState {
  final UserProfileSearchStateStatus status;
  final String? error;
  final List<UserProfileModel> userProfileModelList;
  final int page;
  final int limit;
  final bool firstPage;
  final bool lastPage;
  QueryBuilder<ParseObject> query;
  UserProfileSearchState({
    required this.status,
    this.error,
    required this.userProfileModelList,
    required this.page,
    required this.limit,
    required this.lastPage,
    required this.firstPage,
    required this.query,
  });

  UserProfileSearchState.initial()
      : status = UserProfileSearchStateStatus.initial,
        error = '',
        userProfileModelList = [],
        page = 1,
        limit = 2,
        firstPage = true,
        lastPage = false,
        query =
            QueryBuilder<ParseObject>(ParseObject(UserProfileEntity.className));

  UserProfileSearchState copyWith({
    UserProfileSearchStateStatus? status,
    String? error,
    List<UserProfileModel>? userProfileModelList,
    int? page,
    int? limit,
    bool? lastPage,
    bool? firstPage,
    QueryBuilder<ParseObject>? query,
  }) {
    return UserProfileSearchState(
      status: status ?? this.status,
      error: error ?? this.error,
      userProfileModelList: userProfileModelList ?? this.userProfileModelList,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      lastPage: lastPage ?? this.lastPage,
      firstPage: firstPage ?? this.firstPage,
      query: query ?? this.query,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileSearchState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.userProfileModelList, userProfileModelList) &&
        other.page == page &&
        other.limit == limit &&
        other.lastPage == lastPage &&
        other.firstPage == firstPage &&
        other.query == query;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        userProfileModelList.hashCode ^
        page.hashCode ^
        limit.hashCode ^
        lastPage.hashCode ^
        firstPage.hashCode ^
        query.hashCode;
  }
}
