import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/attendance_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/attendance_repository.dart';
import '../../../../data/b4a/entity/attendance_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'attendance_select_event.dart';
import 'attendance_select_state.dart';

class AttendanceSelectBloc
    extends Bloc<AttendanceSelectEvent, AttendanceSelectState> {
  final AttendanceRepository _repository;
  AttendanceSelectBloc({
    required AttendanceRepository repository,
    required UserProfileModel seller,
    required bool isSingleValue,
  })  : _repository = repository,
        super(AttendanceSelectState.initial(isSingleValue)) {
    on<AttendanceSelectEventStartQuery>(_onAttendanceSelectEventStartQuery);
    on<AttendanceSelectEventPreviousPage>(_onAttendanceSelectEventPreviousPage);
    on<AttendanceSelectEventNextPage>(_onAttendanceSelectEventNextPage);
    on<AttendanceSelectEventFormSubmitted>(
        _onAttendanceSelectEventFormSubmitted);
    on<AttendanceSelectEventUpdateSelectedValues>(
        _onAttendanceSelectEventUpdateSelectedValues);

    add(AttendanceSelectEventStartQuery());
  }
  final List<String> cols = [
    ...AttendanceEntity.selectedCols([
      AttendanceEntity.professional,
      AttendanceEntity.procedure,
      AttendanceEntity.patient,
      AttendanceEntity.healthPlan,
      'healthPlan.healthPlanType',
    ]),
  ];

  FutureOr<void> _onAttendanceSelectEventStartQuery(
      AttendanceSelectEventStartQuery event,
      Emitter<AttendanceSelectState> emit) async {
    emit(state.copyWith(
      status: AttendanceSelectStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(AttendanceEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(AttendanceEntity.className));

      query.orderByAscending('name');
      List<AttendanceModel> listGet = await _repository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
        cols,
      );

      emit(state.copyWith(
        status: AttendanceSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: AttendanceSelectStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onAttendanceSelectEventPreviousPage(
      AttendanceSelectEventPreviousPage event,
      Emitter<AttendanceSelectState> emit) async {
    emit(
      state.copyWith(
        status: AttendanceSelectStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<AttendanceModel> listGet = await _repository.list(
        state.query,
        Pagination(page: state.page, limit: state.limit),
        cols,
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
        status: AttendanceSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: AttendanceSelectStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onAttendanceSelectEventNextPage(
      AttendanceSelectEventNextPage event,
      Emitter<AttendanceSelectState> emit) async {
    emit(
      state.copyWith(status: AttendanceSelectStateStatus.loading),
    );
    List<AttendanceModel> listGet = await _repository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
      cols,
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: AttendanceSelectStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: AttendanceSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onAttendanceSelectEventFormSubmitted(
      AttendanceSelectEventFormSubmitted event,
      Emitter<AttendanceSelectState> emit) {
    if (event.authorizationCode.isEmpty) {
      emit(state.copyWith(listFiltered: state.list));
    } else {
      List<AttendanceModel> listTemp;
      listTemp = state.list
          .where((e) => e.authorizationCode!.contains(event.authorizationCode))
          .toList();
      emit(state.copyWith(listFiltered: listTemp));
    }
  }

  FutureOr<void> _onAttendanceSelectEventUpdateSelectedValues(
      AttendanceSelectEventUpdateSelectedValues event,
      Emitter<AttendanceSelectState> emit) {
    int index =
        state.selectedValues.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<AttendanceModel> temp = [...state.selectedValues];
      temp.removeAt(index);
      emit(state.copyWith(selectedValues: temp));
    } else {
      List<AttendanceModel> temp = [...state.selectedValues];
      temp.add(event.model);
      emit(state.copyWith(selectedValues: temp));
    }
  }
}
