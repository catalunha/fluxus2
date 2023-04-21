import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/healthplantype_model.dart';
import '../../../../data/b4a/entity/healthplantype_entity.dart';

enum HealthPlanTypeSelectStateStatus { initial, loading, success, error }

class HealthPlanTypeSelectState {
  final HealthPlanTypeSelectStateStatus status;
  final String? error;
  final List<HealthPlanTypeModel> list;
  final List<HealthPlanTypeModel> listFiltered;
  final int page;
  final int limit;
  final bool firstPage;
  final bool lastPage;
  QueryBuilder<ParseObject> query;
  final List<HealthPlanTypeModel> selectedValues;
  final bool isSingleValue;

  HealthPlanTypeSelectState({
    required this.status,
    this.error,
    required this.list,
    required this.listFiltered,
    required this.page,
    required this.limit,
    required this.firstPage,
    required this.lastPage,
    required this.query,
    this.selectedValues = const [],
    this.isSingleValue = true,
  });
  HealthPlanTypeSelectState.initial(this.isSingleValue)
      : status = HealthPlanTypeSelectStateStatus.initial,
        error = '',
        list = [],
        listFiltered = [],
        page = 1,
        limit = 20,
        firstPage = true,
        lastPage = false,
        query = QueryBuilder<ParseObject>(
            ParseObject(HealthPlanTypeEntity.className)),
        selectedValues = const [];

  HealthPlanTypeSelectState copyWith({
    HealthPlanTypeSelectStateStatus? status,
    String? error,
    List<HealthPlanTypeModel>? list,
    List<HealthPlanTypeModel>? listFiltered,
    int? page,
    int? limit,
    bool? firstPage,
    bool? lastPage,
    QueryBuilder<ParseObject>? query,
    List<HealthPlanTypeModel>? selectedValues,
    bool? isSingleValue,
  }) {
    return HealthPlanTypeSelectState(
      status: status ?? this.status,
      error: error ?? this.error,
      list: list ?? this.list,
      listFiltered: listFiltered ?? this.listFiltered,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      firstPage: firstPage ?? this.firstPage,
      lastPage: lastPage ?? this.lastPage,
      query: query ?? this.query,
      selectedValues: selectedValues ?? this.selectedValues,
      isSingleValue: isSingleValue ?? this.isSingleValue,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HealthPlanTypeSelectState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.list, list) &&
        listEquals(other.listFiltered, listFiltered) &&
        other.page == page &&
        other.limit == limit &&
        other.firstPage == firstPage &&
        other.lastPage == lastPage &&
        other.query == query &&
        listEquals(other.selectedValues, selectedValues) &&
        other.isSingleValue == isSingleValue;
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
        query.hashCode ^
        selectedValues.hashCode ^
        isSingleValue.hashCode;
  }

  @override
  String toString() {
    return 'HealthPlanTypeSelectState(status: $status, error: $error, list: $list, listFiltered: $listFiltered, page: $page, limit: $limit, firstPage: $firstPage, lastPage: $lastPage, query: $query, selectedValues: $selectedValues, isSingleValue: $isSingleValue)';
  }
}
