import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/graduation_model.dart';
import '../../../../data/b4a/entity/graduation_entity.dart';

enum GraduationSelectStateStatus { initial, loading, success, error }

class GraduationSelectState {
  final GraduationSelectStateStatus status;
  final String? error;
  final List<GraduationModel> list;
  final List<GraduationModel> listFiltered;
  final int page;
  final int limit;
  final bool firstPage;
  final bool lastPage;
  QueryBuilder<ParseObject> query;

  GraduationSelectState({
    required this.status,
    this.error,
    required this.list,
    required this.listFiltered,
    required this.page,
    required this.limit,
    required this.firstPage,
    required this.lastPage,
    required this.query,
  });
  GraduationSelectState.initial()
      : status = GraduationSelectStateStatus.initial,
        error = '',
        list = [],
        listFiltered = [],
        page = 1,
        limit = 2,
        firstPage = true,
        lastPage = false,
        query =
            QueryBuilder<ParseObject>(ParseObject(GraduationEntity.className));

  GraduationSelectState copyWith({
    GraduationSelectStateStatus? status,
    String? error,
    List<GraduationModel>? list,
    List<GraduationModel>? listFiltered,
    int? page,
    int? limit,
    bool? firstPage,
    bool? lastPage,
    QueryBuilder<ParseObject>? query,
  }) {
    return GraduationSelectState(
      status: status ?? this.status,
      error: error ?? this.error,
      list: list ?? this.list,
      listFiltered: listFiltered ?? this.listFiltered,
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

    return other is GraduationSelectState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.list, list) &&
        listEquals(other.listFiltered, listFiltered) &&
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
        listFiltered.hashCode ^
        page.hashCode ^
        limit.hashCode ^
        firstPage.hashCode ^
        lastPage.hashCode ^
        query.hashCode;
  }

  @override
  String toString() {
    return 'GraduationSelectState(status: $status, error: $error, list: $list, listFiltered: $listFiltered, page: $page, limit: $limit, firstPage: $firstPage, lastPage: $lastPage, query: $query)';
  }
}
