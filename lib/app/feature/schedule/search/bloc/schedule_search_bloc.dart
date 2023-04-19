import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/event_model.dart';
import '../../../../core/models/room_model.dart';
import '../../../../core/repositories/event_repository.dart';
import '../../../../core/repositories/room_repository.dart';
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
  }

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
      if (event.selectedRoom) {
        query.whereEqualTo(
            EventEntity.room,
            (ParseObject(RoomEntity.className)..objectId = event.equalsRoom?.id)
                .toPointer());
      }
      if (event.selectedStartEnd) {
        query.whereGreaterThanOrEqualsTo(EventEntity.start,
            DateTime(event.start!.year, event.start!.month, event.start!.day));
        query.whereLessThanOrEqualTo(
            EventEntity.end,
            DateTime(
                event.end!.year, event.end!.month, event.end!.day, 23, 59));
      }

      query.orderByDescending('updatedAt');
      List<EventModel> listGet =
          await _repository.list(query, Pagination(page: 1, limit: 100), [
        'UserProfile.offices',
        'UserProfile.expertises',
        'UserProfile.procedures',
        'Patient.family',
        'Patient.healthPlans',
      ]);
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
/*
  Future<void> createPlanner(DateTime start, DateTime end) async {
    List<TimePlannerTask> timePlannerTasks = [];
    List<TimePlannerTitle> timePlannerHeaders = [];
    int day = 0;
    for (DateTime dayMorning = start;
        dayMorning.isBefore(end.add(const Duration(days: 1)));
        dayMorning = dayMorning.add(const Duration(days: 1))) {
      DateTime dayNight =
          dayMorning.add(const Duration(hours: 23, minutes: 59));
      // timePlannerHeaders.add(TimePlannerTitle());
      for (EventModel e in state.list) {
        if (dayMorning.isBefore(e.start!) && dayNight.isAfter(e.start!)) {
          timePlannerTasks.add(
            TimePlannerTask(
              dateTime: TimePlannerDateTime(
                day: day,
                hour: e.start!.hour,
                minutes: e.start!.minute,
              ),
              minutesDuration: e.duration(),
            ),
          );
        }
      }
      day++;
    }
  }
  */

  FutureOr<void> _onScheduleSearchEventFilterByRoom(
      ScheduleSearchEventFilterByRoom event,
      Emitter<ScheduleSearchState> emit) async {
    List<EventModel> listTemp = [...state.list];
    listTemp = listTemp.where((e) => e.room?.id == event.model.id).toList();
    emit(state.copyWith(listFiltered: [], roomSelected: event.model));
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(listFiltered: listTemp, roomSelected: event.model));
  }
}

/*
  int dif() {
    Duration diff = end.difference(start);
    return diff.inMinutes;
  }


*/