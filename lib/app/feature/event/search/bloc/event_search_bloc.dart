import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/event_model.dart';
import '../../../../core/repositories/event_repository.dart';
import '../../../../data/b4a/entity/attendance_entity.dart';
import '../../../../data/b4a/entity/event_entity.dart';
import '../../../../data/b4a/entity/patient_entity.dart';
import '../../../../data/b4a/entity/procedure_entity.dart';
import '../../../../data/b4a/entity/room_entity.dart';
import '../../../../data/b4a/entity/status_entity.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'event_search_event.dart';
import 'event_search_state.dart';

class EventSearchBloc extends Bloc<EventSearchEvent, EventSearchState> {
  final EventRepository _repository;

  EventSearchBloc({required EventRepository repository})
      : _repository = repository,
        super(EventSearchState.initial()) {
    on<EventSearchEventFormSubmitted>(_onEventSearchEventFormSubmitted);
    on<EventSearchEventNextPage>(_onEventSearchEventNextPage);
    on<EventSearchEventPreviousPage>(_onEventSearchEventPreviousPage);
    on<EventSearchEventUpdateList>(_onEventSearchEventUpdateList);
    on<EventSearchEventRemoveFromList>(_onEventSearchEventRemoveFromList);
  }

  FutureOr<void> _onEventSearchEventPreviousPage(
      EventSearchEventPreviousPage event,
      Emitter<EventSearchState> emit) async {
    emit(
      state.copyWith(
        status: EventSearchStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<EventModel> listGet = await _repository.list(
        state.query,
        Pagination(page: state.page, limit: state.limit),
      );
      if (state.page == 1) {
        emit(
          state.copyWith(
            page: 1,
            firstPage: true,
            lastPage: false,
          ),
        );
      }
      emit(state.copyWith(
        status: EventSearchStateStatus.success,
        list: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: EventSearchStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onEventSearchEventNextPage(
      EventSearchEventNextPage event, Emitter<EventSearchState> emit) async {
    emit(
      state.copyWith(status: EventSearchStateStatus.loading),
    );
    List<EventModel> listGet = await _repository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: EventSearchStateStatus.success,
        // firstPage: false,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: EventSearchStateStatus.success,
        list: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onEventSearchEventFormSubmitted(
      EventSearchEventFormSubmitted event,
      Emitter<EventSearchState> emit) async {
    emit(state.copyWith(
      status: EventSearchStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(EventEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(EventEntity.className));

      if (event.selectedProfessional) {
        // query.whereEqualTo(
        //     EventEntity.professional,
        //     (ParseObject(UserProfileEntity.className)
        //           ..objectId = event.equalsProfessional?.id)
        //         .toPointer());
        QueryBuilder<ParseObject> queryAttendance =
            QueryBuilder<ParseObject>(ParseObject(AttendanceEntity.className));
        queryAttendance.whereEqualTo(
            AttendanceEntity.professional,
            (ParseObject(UserProfileEntity.className)
                  ..objectId = event.equalsProfessional?.id)
                .toPointer());

        query.whereMatchesQuery(EventEntity.attendances, queryAttendance);
      }
      if (event.selectedProcedure) {
        // query.whereEqualTo(
        //     EventEntity.procedure,
        //     (ParseObject(ProcedureEntity.className)
        //           ..objectId = event.equalsProcedure?.id)
        //         .toPointer());
        QueryBuilder<ParseObject> queryAttendance =
            QueryBuilder<ParseObject>(ParseObject(AttendanceEntity.className));
        queryAttendance.whereEqualTo(
            AttendanceEntity.procedure,
            (ParseObject(ProcedureEntity.className)
                  ..objectId = event.equalsProcedure?.id)
                .toPointer());

        query.whereMatchesQuery(EventEntity.attendances, queryAttendance);
      }
      if (event.selectedPatient) {
        // query.whereEqualTo(
        //     EventEntity.patient,
        //     (ParseObject(PatientEntity.className)
        //           ..objectId = event.equalsPatient?.id)
        //         .toPointer());
        QueryBuilder<ParseObject> queryAttendance =
            QueryBuilder<ParseObject>(ParseObject(AttendanceEntity.className));
        queryAttendance.whereEqualTo(
            AttendanceEntity.patient,
            (ParseObject(PatientEntity.className)
                  ..objectId = event.equalsPatient?.id)
                .toPointer());

        query.whereMatchesQuery(EventEntity.attendances, queryAttendance);
      }

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

      query.whereGreaterThanOrEqualsTo(EventEntity.start,
          DateTime(event.start!.year, event.start!.month, event.start!.day));
      query.whereLessThanOrEqualTo(EventEntity.start,
          DateTime(event.end!.year, event.end!.month, event.end!.day, 23, 59));

      query.orderByDescending('updatedAt');
      List<EventModel> listGet = await _repository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );
      emit(state.copyWith(
        status: EventSearchStateStatus.success,
        list: listGet,
        query: query,
      ));
    } catch (_) {
      emit(
        state.copyWith(
            status: EventSearchStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onEventSearchEventUpdateList(
      EventSearchEventUpdateList event, Emitter<EventSearchState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<EventModel> temp = [...state.list];
      temp.replaceRange(index, index + 1, [event.model]);
      emit(state.copyWith(list: temp));
    }
  }

  FutureOr<void> _onEventSearchEventRemoveFromList(
      EventSearchEventRemoveFromList event, Emitter<EventSearchState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<EventModel> temp = [...state.list];
      temp.removeAt(index);
      emit(state.copyWith(list: temp));
    }
  }
}
