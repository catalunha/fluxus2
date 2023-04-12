import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/procedure_model.dart';
import '../../../../data/b4a/entity/procedure_entity.dart';

enum ProcedureSearchStateStatus { initial, loading, success, error }

class ProcedureSearchState {
  final ProcedureSearchStateStatus status;
  final String? error;
  final List<ProcedureModel> list;
  final int page;
  final int limit;
  final bool firstPage;
  final bool lastPage;
  QueryBuilder<ParseObject> query;

  ProcedureSearchState({
    required this.status,
    this.error,
    required this.list,
    required this.page,
    required this.limit,
    required this.firstPage,
    required this.lastPage,
    required this.query,
  });
  ProcedureSearchState.initial()
      : status = ProcedureSearchStateStatus.initial,
        error = '',
        list = [],
        page = 1,
        limit = 2,
        firstPage = true,
        lastPage = false,
        query =
            QueryBuilder<ParseObject>(ParseObject(ProcedureEntity.className));

  ProcedureSearchState copyWith({
    ProcedureSearchStateStatus? status,
    String? error,
    List<ProcedureModel>? list,
    int? page,
    int? limit,
    bool? firstPage,
    bool? lastPage,
    QueryBuilder<ParseObject>? query,
  }) {
    return ProcedureSearchState(
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

    return other is ProcedureSearchState &&
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
    return 'ProcedureSearchState(status: $status, error: $error, list: $list, page: $page, limit: $limit, firstPage: $firstPage, lastPage: $lastPage, query: $query)';
  }
}
