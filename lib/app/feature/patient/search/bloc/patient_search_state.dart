import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/patient_model.dart';
import '../../../../data/b4a/entity/patient_entity.dart';

enum PatientSearchStateStatus { initial, loading, success, error }

class PatientSearchState {
  final PatientSearchStateStatus status;
  final String? error;
  final List<PatientModel> list;
  final int page;
  final int limit;
  final bool firstPage;
  final bool lastPage;
  QueryBuilder<ParseObject> query;
  PatientSearchState({
    required this.status,
    this.error,
    required this.list,
    required this.page,
    required this.limit,
    required this.lastPage,
    required this.firstPage,
    required this.query,
  });

  PatientSearchState.initial()
      : status = PatientSearchStateStatus.initial,
        error = '',
        list = [],
        page = 1,
        limit = 20,
        firstPage = true,
        lastPage = false,
        query = QueryBuilder<ParseObject>(ParseObject(PatientEntity.className));

  PatientSearchState copyWith({
    PatientSearchStateStatus? status,
    String? error,
    List<PatientModel>? list,
    int? page,
    int? limit,
    bool? lastPage,
    bool? firstPage,
    QueryBuilder<ParseObject>? query,
  }) {
    return PatientSearchState(
      status: status ?? this.status,
      error: error ?? this.error,
      list: list ?? this.list,
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

    return other is PatientSearchState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.list, list) &&
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
        list.hashCode ^
        page.hashCode ^
        limit.hashCode ^
        lastPage.hashCode ^
        firstPage.hashCode ^
        query.hashCode;
  }
}
