import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/event_model.dart';
import '../../../../core/models/room_model.dart';
import '../../../../data/b4a/entity/event_entity.dart';

enum ScheduleSearchStateStatus { initial, loading, success, error }

class ScheduleSearchState {
  final ScheduleSearchStateStatus status;
  final String? error;
  final List<RoomModel> rooms;
  final List<EventModel> list;
  final List<EventModel> listFiltered;
  QueryBuilder<ParseObject> query;
  final DateTime? start;
  final DateTime? end;
  final RoomModel? roomSelected;
  ScheduleSearchState({
    required this.status,
    this.error,
    required this.rooms,
    required this.list,
    required this.listFiltered,
    required this.query,
    this.start,
    this.end,
    this.roomSelected,
  });

  ScheduleSearchState.initial()
      : status = ScheduleSearchStateStatus.initial,
        error = '',
        start = null,
        end = null,
        list = [],
        listFiltered = [],
        rooms = [],
        roomSelected = null,
        query = QueryBuilder<ParseObject>(ParseObject(EventEntity.className));

  ScheduleSearchState copyWith({
    ScheduleSearchStateStatus? status,
    String? error,
    List<RoomModel>? rooms,
    List<EventModel>? list,
    List<EventModel>? listFiltered,
    QueryBuilder<ParseObject>? query,
    DateTime? start,
    DateTime? end,
    RoomModel? roomSelected,
  }) {
    return ScheduleSearchState(
      status: status ?? this.status,
      error: error ?? this.error,
      rooms: rooms ?? this.rooms,
      list: list ?? this.list,
      listFiltered: listFiltered ?? this.listFiltered,
      query: query ?? this.query,
      start: start ?? this.start,
      end: end ?? this.end,
      roomSelected: roomSelected ?? this.roomSelected,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScheduleSearchState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.rooms, rooms) &&
        listEquals(other.list, list) &&
        listEquals(other.listFiltered, listFiltered) &&
        other.query == query &&
        other.start == start &&
        other.end == end &&
        other.roomSelected == roomSelected;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        rooms.hashCode ^
        list.hashCode ^
        listFiltered.hashCode ^
        query.hashCode ^
        start.hashCode ^
        end.hashCode ^
        roomSelected.hashCode;
  }

  @override
  String toString() {
    return 'ScheduleSearchState(status: $status, error: $error, rooms: $rooms, list: $list, listFiltered: $listFiltered, query: $query, start: $start, end: $end, roomSelected: $roomSelected)';
  }
}
