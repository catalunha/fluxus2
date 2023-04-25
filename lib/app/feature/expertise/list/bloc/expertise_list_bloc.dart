import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/expertise_model.dart';
import '../../../../core/repositories/expertise_repository.dart';
import '../../../../data/b4a/entity/expertise_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'expertise_list_event.dart';
import 'expertise_list_state.dart';

class ExpertiseListBloc extends Bloc<ExpertiseListEvent, ExpertiseListState> {
  final ExpertiseRepository _repository;
  ExpertiseListBloc({
    required ExpertiseRepository repository,
  })  : _repository = repository,
        super(ExpertiseListState.initial()) {
    on<ExpertiseListEventInitialList>(_onExpertiseListEventInitial);
    on<ExpertiseListEventPreviousPage>(_onExpertiseListEventPreviousPage);
    on<ExpertiseListEventNextPage>(_onUserProfileListEventNextPage);
    on<ExpertiseListEventAddToList>(_onExpertiseListEventAddToList);
    on<ExpertiseListEventUpdateList>(_onExpertiseListEventUpdateList);
    on<ExpertiseListEventRemoveFromList>(_onExpertiseListEventRemoveFromList);
    add(ExpertiseListEventInitialList());
  }

  FutureOr<void> _onExpertiseListEventInitial(
      ExpertiseListEventInitialList event,
      Emitter<ExpertiseListState> emit) async {
    emit(state.copyWith(
      status: ExpertiseListStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(ExpertiseEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(ExpertiseEntity.className));

      query.orderByAscending('name');
      List<ExpertiseModel> listGet = await _repository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: ExpertiseListStateStatus.success,
        list: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: ExpertiseListStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onExpertiseListEventPreviousPage(
      ExpertiseListEventPreviousPage event,
      Emitter<ExpertiseListState> emit) async {
    emit(
      state.copyWith(
        status: ExpertiseListStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<ExpertiseModel> listGet = await _repository.list(
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
        status: ExpertiseListStateStatus.success,
        list: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: ExpertiseListStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileListEventNextPage(
      ExpertiseListEventNextPage event,
      Emitter<ExpertiseListState> emit) async {
    emit(
      state.copyWith(status: ExpertiseListStateStatus.loading),
    );
    List<ExpertiseModel> listGet = await _repository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: ExpertiseListStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: ExpertiseListStateStatus.success,
        list: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onExpertiseListEventAddToList(
      ExpertiseListEventAddToList event, Emitter<ExpertiseListState> emit) {
    List<ExpertiseModel> listTemp = [...state.list];
    listTemp.add(event.model);
    listTemp.sort((a, b) => a.name!.compareTo(b.name!));
    emit(state.copyWith(list: listTemp));
  }

  FutureOr<void> _onExpertiseListEventUpdateList(
      ExpertiseListEventUpdateList event, Emitter<ExpertiseListState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<ExpertiseModel> listTemp = [...state.list];
      listTemp.replaceRange(index, index + 1, [event.model]);
      listTemp.sort((a, b) => a.name!.compareTo(b.name!));
      emit(state.copyWith(list: listTemp));
    }
  }

  FutureOr<void> _onExpertiseListEventRemoveFromList(
      ExpertiseListEventRemoveFromList event,
      Emitter<ExpertiseListState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.id);
    if (index >= 0) {
      List<ExpertiseModel> listTemp = [...state.list];
      listTemp.removeAt(index);
      emit(state.copyWith(list: listTemp));
    }
  }
}
