import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/attendance_model.dart';
import '../../../../core/models/event_model.dart';
import '../../../../core/models/room_model.dart';
import '../../../../core/repositories/event_repository.dart';
import '../../../../core/repositories/room_repository.dart';
import '../../../../data/b4a/entity/attendance_entity.dart';
import '../../../../data/b4a/entity/event_entity.dart';
import '../../../../data/b4a/entity/room_entity.dart';
import '../../../../data/b4a/entity/status_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'schedule_search_event.dart';
import 'schedule_search_state.dart';

class ScheduleSearchBloc
    extends Bloc<ScheduleSearchEvent, ScheduleSearchState> {
  final EventRepository _repository;
  final RoomRepository _repositoryRoom;

  ScheduleSearchBloc({
    required EventRepository repository,
    required RoomRepository repositoryRoom,
  })  : _repository = repository,
        _repositoryRoom = repositoryRoom,
        super(ScheduleSearchState.initial()) {
    on<ScheduleSearchEventFormSubmitted>(_onScheduleSearchEventFormSubmitted);
    on<ScheduleSearchEventFilterByRoom>(_onScheduleSearchEventFilterByRoom);
    on<ScheduleSearchEventUpdateAttendances>(
        _onScheduleSearchEventUpdateAttendances);
    on<ScheduleSearchEventUpdateList>(_onScheduleSearchEventUpdateList);
    on<ScheduleSearchEventRemoveFromList>(_onScheduleSearchEventRemoveFromList);
  }
  final List<String> cols = [
    ...EventEntity.selectedCols([
      EventEntity.attendances,
      EventEntity.status,
      EventEntity.room,
      EventEntity.start,
      EventEntity.end,
    ]),
    ...AttendanceEntity.selectedCols([
      AttendanceEntity.professional,
      AttendanceEntity.procedure,
      AttendanceEntity.patient,
      AttendanceEntity.healthPlan,
      'healthPlan.healthPlanType',
    ]),
  ];
  FutureOr<void> _onScheduleSearchEventFormSubmitted(
      ScheduleSearchEventFormSubmitted event,
      Emitter<ScheduleSearchState> emit) async {
    emit(state.copyWith(
      status: ScheduleSearchStateStatus.loading,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(EventEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(EventEntity.className));

      if (event.selectedStatus) {
        query.whereEqualTo(
            EventEntity.status,
            (ParseObject(StatusEntity.className)
                  ..objectId = event.equalsStatus?.id)
                .toPointer());
      }

      query.whereGreaterThanOrEqualsTo(EventEntity.start,
          DateTime(event.start!.year, event.start!.month, event.start!.day));
      query.whereLessThanOrEqualTo(EventEntity.end,
          DateTime(event.end!.year, event.end!.month, event.end!.day, 23, 59));

      query.orderByDescending('updatedAt');
      List<EventModel> listGet = await _repository.list(
        query,
        Pagination(page: 1, limit: 100),
        cols,
      );
      QueryBuilder<ParseObject> queryRoom =
          QueryBuilder<ParseObject>(ParseObject(RoomEntity.className));
      queryRoom.orderByAscending('name');

      List<RoomModel> rooms =
          await _repositoryRoom.list(queryRoom, Pagination(page: 1, limit: 20));

      emit(state.copyWith(
        rooms: rooms,
        roomSelected: rooms[0],
        list: listGet,
        listFiltered: listGet,
        query: query,
        start: event.start,
        end: event.end,
      ));
      add(ScheduleSearchEventFilterByRoom(state.roomSelected!));
      emit(state.copyWith(
        status: ScheduleSearchStateStatus.success,
      ));
    } catch (_) {
      emit(
        state.copyWith(
            status: ScheduleSearchStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onScheduleSearchEventFilterByRoom(
      ScheduleSearchEventFilterByRoom event,
      Emitter<ScheduleSearchState> emit) {
    print('filter by room...');
    List<EventModel> listTemp = [...state.list];
    listTemp = listTemp.where((e) => e.room?.id == event.model.id).toList();
    emit(state.copyWith(listFiltered: listTemp, roomSelected: event.model));
  }

  FutureOr<void> _onScheduleSearchEventUpdateAttendances(
      ScheduleSearchEventUpdateAttendances event,
      Emitter<ScheduleSearchState> emit) {
    print('updated...${event.event.id}');
    final List<AttendanceModel> attendancesConfimed = [...event.attendances];
    EventModel eventWithAttendancesForUpdated = event.event;
    List<AttendanceModel> attendancesDirty = [
      ...eventWithAttendancesForUpdated.attendances!
    ];
    List<AttendanceModel> attendancesDirtyFinal = [
      ...eventWithAttendancesForUpdated.attendances!
    ];
    for (var attendanceDirty in attendancesDirty) {
      for (var attendanceConfimed in attendancesConfimed) {
        if (attendanceDirty.id == attendanceConfimed.id) {
          int index = attendancesDirtyFinal
              .indexWhere((model) => model.id == attendanceDirty.id);
          if (index >= 0) {
            attendancesDirtyFinal
                .replaceRange(index, index + 1, [attendanceConfimed]);
          }
        }
      }
    }
    eventWithAttendancesForUpdated = eventWithAttendancesForUpdated.copyWith(
        attendances: attendancesDirtyFinal);

    int index = state.list
        .indexWhere((model) => model.id == eventWithAttendancesForUpdated.id);
    if (index >= 0) {
      print('$index');
      List<EventModel> temp = [...state.list];
      temp.replaceRange(index, index + 1, [eventWithAttendancesForUpdated]);
      print(temp);
      emit(state.copyWith(list: temp));
    }
    add(ScheduleSearchEventFilterByRoom(state.roomSelected!));
  }

  FutureOr<void> _onScheduleSearchEventUpdateList(
      ScheduleSearchEventUpdateList event, Emitter<ScheduleSearchState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    List<EventModel> temp = [...state.list];
    if (index >= 0) {
      temp.replaceRange(index, index + 1, [event.model]);
    } else {
      temp.add(event.model);
    }
    emit(state.copyWith(list: temp, roomSelected: event.model.room!));
    add(ScheduleSearchEventFilterByRoom(state.roomSelected!));
  }

  FutureOr<void> _onScheduleSearchEventRemoveFromList(
      ScheduleSearchEventRemoveFromList event,
      Emitter<ScheduleSearchState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<EventModel> temp = [...state.list];
      temp.removeAt(index);
      emit(state.copyWith(list: temp));
      add(ScheduleSearchEventFilterByRoom(state.roomSelected!));
    }
  }
}
