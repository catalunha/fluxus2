import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/attendance_model.dart';
import '../../../../core/repositories/attendance_repository.dart';
import '../../../../data/b4a/entity/attendance_entity.dart';
import '../../../../data/b4a/entity/patient_entity.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'attendance_search_event.dart';
import 'attendance_search_state.dart';

class AttendanceSearchBloc
    extends Bloc<AttendanceSearchEvent, AttendanceSearchState> {
  final AttendanceRepository _repository;
  AttendanceSearchBloc({
    required AttendanceRepository repository,
  })  : _repository = repository,
        super(AttendanceSearchState.initial()) {
    on<AttendanceSearchEventFormSubmitted>(
        _onAttendanceSearchEventFormSubmitted);
    on<AttendanceSearchEventPreviousPage>(_onAttendanceSearchEventPreviousPage);
    on<AttendanceSearchEventNextPage>(_onUserProfileSearchEventNextPage);
    on<AttendanceSearchEventUpdateList>(_onAttendanceSearchEventUpdateList);
    on<AttendanceSearchEventRemoveFromList>(
        _onAttendanceSearchEventRemoveFromList);
  }

  FutureOr<void> _onAttendanceSearchEventFormSubmitted(
      AttendanceSearchEventFormSubmitted event,
      Emitter<AttendanceSearchState> emit) async {
    emit(state.copyWith(
      status: AttendanceSearchStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(AttendanceEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(AttendanceEntity.className));

      if (event.selectedProfessional) {
        query.whereEqualTo(
            AttendanceEntity.professional,
            (ParseObject(UserProfileEntity.className)
                  ..objectId = event.professional?.id)
                .toPointer());
      }
      if (event.selectedPatient) {
        query.whereEqualTo(
            AttendanceEntity.patient,
            (ParseObject(PatientEntity.className)..objectId = event.patient?.id)
                .toPointer());
      }
      if (event.selectedStartEnd) {
        query.whereGreaterThanOrEqualsTo('createdAt',
            DateTime(event.start!.year, event.start!.month, event.start!.day));
        query.whereLessThanOrEqualTo(
            'createdAt',
            DateTime(
                event.end!.year, event.end!.month, event.end!.day, 23, 59));
      }
      query.orderByDescending('updatedAt');
      List<AttendanceModel> modelListGet = await _repository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: AttendanceSearchStateStatus.success,
        list: modelListGet,
        query: query,
      ));
    } catch (e) {
      print(e);
      emit(
        state.copyWith(
            status: AttendanceSearchStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onAttendanceSearchEventPreviousPage(
      AttendanceSearchEventPreviousPage event,
      Emitter<AttendanceSearchState> emit) async {
    emit(
      state.copyWith(
        status: AttendanceSearchStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<AttendanceModel> AttendanceModelListGet = await _repository.list(
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
        status: AttendanceSearchStateStatus.success,
        list: AttendanceModelListGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: AttendanceSearchStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileSearchEventNextPage(
      AttendanceSearchEventNextPage event,
      Emitter<AttendanceSearchState> emit) async {
    emit(
      state.copyWith(status: AttendanceSearchStateStatus.loading),
    );
    List<AttendanceModel> AttendanceModelListGet = await _repository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (AttendanceModelListGet.isEmpty) {
      emit(state.copyWith(
        status: AttendanceSearchStateStatus.success,
        // firstPage: false,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: AttendanceSearchStateStatus.success,
        list: AttendanceModelListGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onAttendanceSearchEventUpdateList(
      AttendanceSearchEventUpdateList event,
      Emitter<AttendanceSearchState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<AttendanceModel> tempList = [...state.list];
      tempList.replaceRange(index, index + 1, [event.model]);
      emit(state.copyWith(list: tempList));
    }
  }

  FutureOr<void> _onAttendanceSearchEventRemoveFromList(
      AttendanceSearchEventRemoveFromList event,
      Emitter<AttendanceSearchState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.modelId);
    if (index >= 0) {
      List<AttendanceModel> tempList = [...state.list];
      tempList.removeAt(index);
      emit(state.copyWith(list: tempList));
    }
  }
}
