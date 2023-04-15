import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/healthplantype_model.dart';
import '../../../../core/repositories/healthplantype_repository.dart';
import '../../../../data/b4a/entity/healthplantype_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'healthplantype_list_event.dart';
import 'healthplantype_list_state.dart';

class HealthPlanTypeListBloc
    extends Bloc<HealthPlanTypeListEvent, HealthPlanTypeListState> {
  final HealthPlanTypeRepository _repository;
  HealthPlanTypeListBloc({
    required HealthPlanTypeRepository repository,
  })  : _repository = repository,
        super(HealthPlanTypeListState.initial()) {
    on<HealthPlanTypeListEventInitialList>(_onHealthPlanTypeListEventInitial);
    on<HealthPlanTypeListEventPreviousPage>(
        _onHealthPlanTypeListEventPreviousPage);
    on<HealthPlanTypeListEventNextPage>(_onUserProfileListEventNextPage);
    on<HealthPlanTypeListEventUpdateList>(_onHealthPlanTypeListEventUpdateList);
    on<HealthPlanTypeListEventRemoveFromList>(
        _onHealthPlanTypeListEventRemoveFromList);
    add(HealthPlanTypeListEventInitialList());
  }

  FutureOr<void> _onHealthPlanTypeListEventInitial(
      HealthPlanTypeListEventInitialList event,
      Emitter<HealthPlanTypeListState> emit) async {
    emit(state.copyWith(
      status: HealthPlanTypeListStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(
          ParseObject(HealthPlanTypeEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query = QueryBuilder<ParseObject>(
          ParseObject(HealthPlanTypeEntity.className));

      query.orderByAscending('name');
      List<HealthPlanTypeModel> listGet = await _repository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: HealthPlanTypeListStateStatus.success,
        list: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: HealthPlanTypeListStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onHealthPlanTypeListEventPreviousPage(
      HealthPlanTypeListEventPreviousPage event,
      Emitter<HealthPlanTypeListState> emit) async {
    emit(
      state.copyWith(
        status: HealthPlanTypeListStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<HealthPlanTypeModel> listGet = await _repository.list(
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
        status: HealthPlanTypeListStateStatus.success,
        list: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: HealthPlanTypeListStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileListEventNextPage(
      HealthPlanTypeListEventNextPage event,
      Emitter<HealthPlanTypeListState> emit) async {
    emit(
      state.copyWith(status: HealthPlanTypeListStateStatus.loading),
    );
    List<HealthPlanTypeModel> listGet = await _repository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: HealthPlanTypeListStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: HealthPlanTypeListStateStatus.success,
        list: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onHealthPlanTypeListEventUpdateList(
      HealthPlanTypeListEventUpdateList event,
      Emitter<HealthPlanTypeListState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<HealthPlanTypeModel> listTemp = [...state.list];
      listTemp.replaceRange(index, index + 1, [event.model]);
      emit(state.copyWith(list: listTemp));
    }
  }

  FutureOr<void> _onHealthPlanTypeListEventRemoveFromList(
      HealthPlanTypeListEventRemoveFromList event,
      Emitter<HealthPlanTypeListState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.id);
    if (index >= 0) {
      List<HealthPlanTypeModel> listTemp = [...state.list];
      listTemp.removeAt(index);
      emit(state.copyWith(list: listTemp));
    }
  }
}
