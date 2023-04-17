import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/Status_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/Status_repository.dart';
import '../../../../data/b4a/entity/Status_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'Status_select_event.dart';
import 'Status_select_state.dart';

class StatusSelectBloc extends Bloc<StatusSelectEvent, StatusSelectState> {
  final StatusRepository _repository;
  StatusSelectBloc({
    required StatusRepository repository,
    required UserProfileModel seller,
    required bool isSingleValue,
  })  : _repository = repository,
        super(StatusSelectState.initial(isSingleValue)) {
    on<StatusSelectEventStartQuery>(_onStatusSelectEventStartQuery);
    on<StatusSelectEventPreviousPage>(_onStatusSelectEventPreviousPage);
    on<StatusSelectEventNextPage>(_onStatusSelectEventNextPage);
    on<StatusSelectEventFormSubmitted>(_onStatusSelectEventFormSubmitted);
    on<StatusSelectEventUpdateSelectedValues>(
        _onStatusSelectEventUpdateSelectedValues);

    add(StatusSelectEventStartQuery());
  }

  FutureOr<void> _onStatusSelectEventStartQuery(
      StatusSelectEventStartQuery event,
      Emitter<StatusSelectState> emit) async {
    emit(state.copyWith(
      status: StatusSelectStateStatus.loading,
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
        status: StatusSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: StatusSelectStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onStatusSelectEventPreviousPage(
      StatusSelectEventPreviousPage event,
      Emitter<StatusSelectState> emit) async {
    emit(
      state.copyWith(
        status: StatusSelectStateStatus.loading,
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
        status: StatusSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: StatusSelectStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onStatusSelectEventNextPage(
      StatusSelectEventNextPage event, Emitter<StatusSelectState> emit) async {
    emit(
      state.copyWith(status: StatusSelectStateStatus.loading),
    );
    List<StatusModel> listGet = await _repository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: StatusSelectStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: StatusSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onStatusSelectEventFormSubmitted(
      StatusSelectEventFormSubmitted event, Emitter<StatusSelectState> emit) {
    if (event.name.isEmpty) {
      emit(state.copyWith(listFiltered: state.list));
    } else {
      List<StatusModel> listTemp;
      listTemp = state.list.where((e) => e.name!.contains(event.name)).toList();
      emit(state.copyWith(listFiltered: listTemp));
    }
  }

  FutureOr<void> _onStatusSelectEventUpdateSelectedValues(
      StatusSelectEventUpdateSelectedValues event,
      Emitter<StatusSelectState> emit) {
    int index =
        state.selectedValues.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<StatusModel> temp = [...state.selectedValues];
      temp.removeAt(index);
      emit(state.copyWith(selectedValues: temp));
    } else {
      List<StatusModel> temp = [...state.selectedValues];
      temp.add(event.model);
      emit(state.copyWith(selectedValues: temp));
    }
  }
}
