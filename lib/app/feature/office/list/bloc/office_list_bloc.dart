import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/office_model.dart';
import '../../../../core/repositories/office_repository.dart';
import '../../../../data/b4a/entity/office_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'office_list_event.dart';
import 'office_list_state.dart';

class OfficeListBloc extends Bloc<OfficeListEvent, OfficeListState> {
  final OfficeRepository _repository;
  OfficeListBloc({
    required OfficeRepository repository,
  })  : _repository = repository,
        super(OfficeListState.initial()) {
    on<OfficeListEventInitialList>(_onOfficeListEventInitial);
    on<OfficeListEventPreviousPage>(_onOfficeListEventPreviousPage);
    on<OfficeListEventNextPage>(_onUserProfileListEventNextPage);
    on<OfficeListEventAddToList>(_onOfficeListEventAddToList);
    on<OfficeListEventUpdateList>(_onOfficeListEventUpdateList);
    on<OfficeListEventRemoveFromList>(_onOfficeListEventRemoveFromList);
    add(OfficeListEventInitialList());
  }

  FutureOr<void> _onOfficeListEventInitial(
      OfficeListEventInitialList event, Emitter<OfficeListState> emit) async {
    emit(state.copyWith(
      status: OfficeListStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(OfficeEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(OfficeEntity.className));

      query.orderByAscending('name');
      List<OfficeModel> listGet = await _repository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: OfficeListStateStatus.success,
        list: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: OfficeListStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onOfficeListEventPreviousPage(
      OfficeListEventPreviousPage event, Emitter<OfficeListState> emit) async {
    emit(
      state.copyWith(
        status: OfficeListStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<OfficeModel> listGet = await _repository.list(
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
        status: OfficeListStateStatus.success,
        list: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: OfficeListStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileListEventNextPage(
      OfficeListEventNextPage event, Emitter<OfficeListState> emit) async {
    emit(
      state.copyWith(status: OfficeListStateStatus.loading),
    );
    List<OfficeModel> listGet = await _repository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: OfficeListStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: OfficeListStateStatus.success,
        list: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onOfficeListEventAddToList(
      OfficeListEventAddToList event, Emitter<OfficeListState> emit) {
    List<OfficeModel> listTemp = [...state.list];
    listTemp.add(event.model);
    emit(state.copyWith(list: listTemp));
  }

  FutureOr<void> _onOfficeListEventUpdateList(
      OfficeListEventUpdateList event, Emitter<OfficeListState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<OfficeModel> listTemp = [...state.list];
      listTemp.replaceRange(index, index + 1, [event.model]);
      emit(state.copyWith(list: listTemp));
    }
  }

  FutureOr<void> _onOfficeListEventRemoveFromList(
      OfficeListEventRemoveFromList event, Emitter<OfficeListState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.id);
    if (index >= 0) {
      List<OfficeModel> listTemp = [...state.list];
      listTemp.removeAt(index);
      emit(state.copyWith(list: listTemp));
    }
  }
}
