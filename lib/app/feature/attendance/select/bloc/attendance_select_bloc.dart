import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/Attendance_model.dart';
import '../../../../core/repositories/Attendance_repository.dart';
import '../../../../data/b4a/entity/Attendance_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'Attendance_select_event.dart';
import 'Attendance_select_state.dart';

class AttendanceSelectBloc
    extends Bloc<AttendanceSelectEvent, AttendanceSelectState> {
  final AttendanceRepository _AttendanceRepository;
  AttendanceSelectBloc({required AttendanceRepository AttendanceRepository})
      : _AttendanceRepository = AttendanceRepository,
        super(AttendanceSelectState.initial()) {
    on<AttendanceSelectEventStartQuery>(_onAttendanceSelectEventStartQuery);
    on<AttendanceSelectEventPreviousPage>(_onAttendanceSelectEventPreviousPage);
    on<AttendanceSelectEventNextPage>(_onAttendanceSelectEventNextPage);
    on<AttendanceSelectEventFormSubmitted>(
        _onAttendanceSelectEventFormSubmitted);
    add(AttendanceSelectEventStartQuery());
  }

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
      List<AttendanceModel> listGet = await _AttendanceRepository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
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
      List<AttendanceModel> listGet = await _AttendanceRepository.list(
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
    List<AttendanceModel> listGet = await _AttendanceRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
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
    if (event.name.isEmpty) {
      emit(state.copyWith(listFiltered: state.list));
    } else {
      List<AttendanceModel> listTemp;
      listTemp = state.list.where((e) => e.name!.contains(event.name)).toList();
      emit(state.copyWith(listFiltered: listTemp));
    }
  }
}
