import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:time_planner/time_planner.dart';

import '../../../../core/models/event_model.dart';
import '../../../../data/b4a/entity/event_entity.dart';

enum ScheduleSearchStateStatus { initial, loading, success, error }

class ScheduleSearchState {
  final ScheduleSearchStateStatus status;
  final String? error;
  final List<EventModel> list;
  QueryBuilder<ParseObject> query;
  List<TimePlannerTask> timePlannerTasks;
  List<TimePlannerTitle> timePlannerHeaders;
  final DateTime? start;
  final DateTime? end;
  ScheduleSearchState({
    required this.status,
    this.error,
    required this.list,
    required this.query,
    this.timePlannerTasks = const [],
    this.timePlannerHeaders = const [],
    this.start,
    this.end,
  });

  ScheduleSearchState.initial()
      : status = ScheduleSearchStateStatus.initial,
        error = '',
        start = null,
        end = null,
        list = [],
        timePlannerTasks = const [],
        timePlannerHeaders = const [],
        query = QueryBuilder<ParseObject>(ParseObject(EventEntity.className));

  ScheduleSearchState copyWith({
    ScheduleSearchStateStatus? status,
    String? error,
    List<EventModel>? list,
    QueryBuilder<ParseObject>? query,
    List<TimePlannerTask>? timePlannerTasks,
    List<TimePlannerTitle>? timePlannerHeaders,
    DateTime? start,
    DateTime? end,
  }) {
    return ScheduleSearchState(
      status: status ?? this.status,
      error: error ?? this.error,
      list: list ?? this.list,
      query: query ?? this.query,
      timePlannerTasks: timePlannerTasks ?? this.timePlannerTasks,
      timePlannerHeaders: timePlannerHeaders ?? this.timePlannerHeaders,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScheduleSearchState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.list, list) &&
        other.query == query &&
        listEquals(other.timePlannerTasks, timePlannerTasks) &&
        listEquals(other.timePlannerHeaders, timePlannerHeaders) &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        list.hashCode ^
        query.hashCode ^
        timePlannerTasks.hashCode ^
        timePlannerHeaders.hashCode ^
        start.hashCode ^
        end.hashCode;
  }

  @override
  String toString() {
    return 'ScheduleSearchState(status: $status, error: $error, list: $list, query: $query, timePlannerTasks: $timePlannerTasks, timePlannerHeaders: $timePlannerHeaders, start: $start, end: $end)';
  }
}
