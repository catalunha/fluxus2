import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/procedure_model.dart';
import '../../../../core/repositories/procedure_repository.dart';
import '../../../../data/b4a/entity/procedure_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'procedure_search_event.dart';
import 'procedure_search_state.dart';

class ProcedureSearchBloc
    extends Bloc<ProcedureSearchEvent, ProcedureSearchState> {
  final ProcedureRepository _repository;
  ProcedureSearchBloc({required ProcedureRepository repository})
      : _repository = repository,
        super(ProcedureSearchState.initial()) {
    on<ProcedureSearchEventFormSubmitted>(_onProcedureSearchEventFormSubmitted);
    on<ProcedureSearchEventPreviousPage>(_onProcedureSearchEventPreviousPage);
    on<ProcedureSearchEventNextPage>(_onUserProfileSearchEventNextPage);
    on<ProcedureSearchEventUpdateList>(_onProcedureSearchEventUpdateList);
    on<ProcedureSearchEventRemoveFromList>(
        _onProcedureSearchEventRemoveFromList);
  }

  FutureOr<void> _onProcedureSearchEventFormSubmitted(
      ProcedureSearchEventFormSubmitted event,
      Emitter<ProcedureSearchState> emit) async {
    emit(state.copyWith(
      status: ProcedureSearchStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(ProcedureEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(ProcedureEntity.className));

      if (event.nameContainsBool) {
        query.whereContains(ProcedureEntity.name, event.nameContainsString);
      }
      if (event.codeEqualsToBool) {
        query.whereEqualTo(ProcedureEntity.code, event.codeEqualsToString);
      }

      query.orderByDescending('updatedAt');
      List<ProcedureModel> addressModelListGet = await _repository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: ProcedureSearchStateStatus.success,
        list: addressModelListGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: ProcedureSearchStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onProcedureSearchEventPreviousPage(
      ProcedureSearchEventPreviousPage event,
      Emitter<ProcedureSearchState> emit) async {
    emit(
      state.copyWith(
        status: ProcedureSearchStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<ProcedureModel> addressModelListGet = await _repository.list(
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
        status: ProcedureSearchStateStatus.success,
        list: addressModelListGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: ProcedureSearchStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileSearchEventNextPage(
      ProcedureSearchEventNextPage event,
      Emitter<ProcedureSearchState> emit) async {
    emit(
      state.copyWith(status: ProcedureSearchStateStatus.loading),
    );
    List<ProcedureModel> addressModelListGet = await _repository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (addressModelListGet.isEmpty) {
      emit(state.copyWith(
        status: ProcedureSearchStateStatus.success,
        // firstPage: false,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: ProcedureSearchStateStatus.success,
        list: addressModelListGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onProcedureSearchEventUpdateList(
      ProcedureSearchEventUpdateList event,
      Emitter<ProcedureSearchState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<ProcedureModel> addressModelListTemp = [...state.list];
      addressModelListTemp.replaceRange(index, index + 1, [event.model]);
      emit(state.copyWith(list: addressModelListTemp));
    }
  }

  FutureOr<void> _onProcedureSearchEventRemoveFromList(
      ProcedureSearchEventRemoveFromList event,
      Emitter<ProcedureSearchState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.modelId);
    if (index >= 0) {
      List<ProcedureModel> addressModelListTemp = [...state.list];
      addressModelListTemp.removeAt(index);
      emit(state.copyWith(list: addressModelListTemp));
    }
  }
}
