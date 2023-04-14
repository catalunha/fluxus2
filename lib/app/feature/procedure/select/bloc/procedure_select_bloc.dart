import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/procedure_model.dart';
import '../../../../core/repositories/procedure_repository.dart';
import '../../../../data/b4a/entity/procedure_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'procedure_select_event.dart';
import 'procedure_select_state.dart';

class ProcedureSelectBloc
    extends Bloc<ProcedureSelectEvent, ProcedureSelectState> {
  final ProcedureRepository _repository;
  ProcedureSelectBloc({
    required ProcedureRepository repository,
    required bool isSingleValue,
  })  : _repository = repository,
        super(ProcedureSelectState.initial(isSingleValue)) {
    on<ProcedureSelectEventStartQuery>(_onProcedureSelectEventStartQuery);
    on<ProcedureSelectEventPreviousPage>(_onProcedureSelectEventPreviousPage);
    on<ProcedureSelectEventNextPage>(_onProcedureSelectEventNextPage);
    on<ProcedureSelectEventFormSubmitted>(_onProcedureSelectEventFormSubmitted);
    on<ProcedureSelectEventUpdateSelectedValues>(
        _onProcedureSelectEventUpdateSelectedValues);
    add(ProcedureSelectEventStartQuery());
  }

  FutureOr<void> _onProcedureSelectEventStartQuery(
      ProcedureSelectEventStartQuery event,
      Emitter<ProcedureSelectState> emit) async {
    emit(state.copyWith(
      status: ProcedureSelectStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(ProcedureEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(ProcedureEntity.className));

      query.orderByAscending('name');
      List<ProcedureModel> listGet = await _repository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: ProcedureSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: ProcedureSelectStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onProcedureSelectEventPreviousPage(
      ProcedureSelectEventPreviousPage event,
      Emitter<ProcedureSelectState> emit) async {
    emit(
      state.copyWith(
        status: ProcedureSelectStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<ProcedureModel> listGet = await _repository.list(
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
        status: ProcedureSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: ProcedureSelectStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onProcedureSelectEventNextPage(
      ProcedureSelectEventNextPage event,
      Emitter<ProcedureSelectState> emit) async {
    emit(
      state.copyWith(status: ProcedureSelectStateStatus.loading),
    );
    List<ProcedureModel> listGet = await _repository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: ProcedureSelectStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: ProcedureSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onProcedureSelectEventFormSubmitted(
      ProcedureSelectEventFormSubmitted event,
      Emitter<ProcedureSelectState> emit) {
    if (event.name.isEmpty) {
      emit(state.copyWith(listFiltered: state.list));
    } else {
      List<ProcedureModel> listTemp;
      listTemp = state.list.where((e) => e.name!.contains(event.name)).toList();
      emit(state.copyWith(listFiltered: listTemp));
    }
  }

  FutureOr<void> _onProcedureSelectEventUpdateSelectedValues(
      ProcedureSelectEventUpdateSelectedValues event,
      Emitter<ProcedureSelectState> emit) {
    int index =
        state.selectedValues.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<ProcedureModel> temp = [...state.selectedValues];
      temp.removeAt(index);
      emit(state.copyWith(selectedValues: temp));
    } else {
      List<ProcedureModel> temp = [...state.selectedValues];
      temp.add(event.model);
      emit(state.copyWith(selectedValues: temp));
    }
  }
}
