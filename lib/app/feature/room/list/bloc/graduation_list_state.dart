import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/graduation_model.dart';
import '../../../../data/b4a/entity/graduation_entity.dart';

enum GraduationListStateStatus { initial, loading, success, error }

class GraduationListState {
  final GraduationListStateStatus status;
  final String? error;
  final List<GraduationModel> list;
  final int page;
  final int limit;
  final bool firstPage;
  final bool lastPage;
  QueryBuilder<ParseObject> query;

  GraduationListState({
    required this.status,
    this.error,
    required this.list,
    required this.page,
    required this.limit,
    required this.firstPage,
    required this.lastPage,
    required this.query,
  });
  GraduationListState.initial()
      : status = GraduationListStateStatus.initial,
        error = '',
        list = [],
        page = 1,
        limit = 2,
        firstPage = true,
        lastPage = false,
        query =
            QueryBuilder<ParseObject>(ParseObject(GraduationEntity.className));

  GraduationListState copyWith({
    GraduationListStateStatus? status,
    String? error,
    List<GraduationModel>? list,
    int? page,
    int? limit,
    bool? firstPage,
    bool? lastPage,
    QueryBuilder<ParseObject>? query,
  }) {
    return GraduationListState(
      status: status ?? this.status,
      error: error ?? this.error,
      list: list ?? this.list,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      firstPage: firstPage ?? this.firstPage,
      lastPage: lastPage ?? this.lastPage,
      query: query ?? this.query,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GraduationListState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.list, list) &&
        other.page == page &&
        other.limit == limit &&
        other.firstPage == firstPage &&
        other.lastPage == lastPage &&
        other.query == query;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        list.hashCode ^
        page.hashCode ^
        limit.hashCode ^
        firstPage.hashCode ^
        lastPage.hashCode ^
        query.hashCode;
  }

  @override
  String toString() {
    return 'GraduationListState(status: $status, error: $error, list: $list, page: $page, limit: $limit, firstPage: $firstPage, lastPage: $lastPage, query: $query)';
  }
}
