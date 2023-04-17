import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/status_model.dart';
import '../../../../core/repositories/status_repository.dart';
import '../../../../data/b4a/entity/status_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'status_list_event.dart';
import 'status_list_state.dart';

class StatusListBloc extends Bloc<StatusListEvent, StatusListState> {
  final StatusRepository _repository;
  StatusListBloc({
    required StatusRepository repository,
  })  : _repository = repository,
        super(StatusListState.initial()) {
    on<StatusListEventInitialList>(_onStatusListEventInitial);
    on<StatusListEventPreviousPage>(_onStatusListEventPreviousPage);
    on<StatusListEventNextPage>(_onUserProfileListEventNextPage);
    on<StatusListEventAddToList>(_onStatusListEventAddToList);
    on<StatusListEventUpdateList>(_onStatusListEventUpdateList);
    on<StatusListEventRemoveFromList>(_onStatusListEventRemoveFromList);
    add(StatusListEventInitialList());
  }

  FutureOr<void> _onStatusListEventInitial(
      StatusListEventInitialList event, Emitter<StatusListState> emit) async {
    emit(state.copyWith(
      status: StatusListStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(StatusEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(StatusEntity.className));

      query.orderByAscending('name');
      List<StatusModel> listGet = await _repository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: StatusListStateStatus.success,
        list: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: StatusListStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onStatusListEventPreviousPage(
      StatusListEventPreviousPage event, Emitter<StatusListState> emit) async {
    emit(
      state.copyWith(
        status: StatusListStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<StatusModel> listGet = await _repository.list(
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
        status: StatusListStateStatus.success,
        list: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: StatusListStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileListEventNextPage(
      StatusListEventNextPage event, Emitter<StatusListState> emit) async {
    emit(
      state.copyWith(status: StatusListStateStatus.loading),
    );
    List<StatusModel> listGet = await _repository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: StatusListStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: StatusListStateStatus.success,
        list: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onStatusListEventAddToList(
      StatusListEventAddToList event, Emitter<StatusListState> emit) {
    List<StatusModel> listTemp = [...state.list];
    listTemp.add(event.model);
    emit(state.copyWith(list: listTemp));
  }

  FutureOr<void> _onStatusListEventUpdateList(
      StatusListEventUpdateList event, Emitter<StatusListState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<StatusModel> listTemp = [...state.list];
      listTemp.replaceRange(index, index + 1, [event.model]);
      emit(state.copyWith(list: listTemp));
    }
  }

  FutureOr<void> _onStatusListEventRemoveFromList(
      StatusListEventRemoveFromList event, Emitter<StatusListState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.id);
    if (index >= 0) {
      List<StatusModel> listTemp = [...state.list];
      listTemp.removeAt(index);
      emit(state.copyWith(list: listTemp));
    }
  }
}
