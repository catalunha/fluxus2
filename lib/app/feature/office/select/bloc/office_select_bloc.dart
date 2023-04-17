import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/office_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/office_repository.dart';
import '../../../../data/b4a/entity/office_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'office_select_event.dart';
import 'office_select_state.dart';

class OfficeSelectBloc extends Bloc<OfficeSelectEvent, OfficeSelectState> {
  final OfficeRepository _repository;
  OfficeSelectBloc({
    required OfficeRepository repository,
    required UserProfileModel seller,
    required bool isSingleValue,
  })  : _repository = repository,
        super(OfficeSelectState.initial(isSingleValue)) {
    on<OfficeSelectEventStartQuery>(_onOfficeSelectEventStartQuery);
    on<OfficeSelectEventPreviousPage>(_onOfficeSelectEventPreviousPage);
    on<OfficeSelectEventNextPage>(_onOfficeSelectEventNextPage);
    on<OfficeSelectEventFormSubmitted>(_onOfficeSelectEventFormSubmitted);
    on<OfficeSelectEventUpdateSelectedValues>(
        _onOfficeSelectEventUpdateSelectedValues);

    add(OfficeSelectEventStartQuery());
  }

  FutureOr<void> _onOfficeSelectEventStartQuery(
      OfficeSelectEventStartQuery event,
      Emitter<OfficeSelectState> emit) async {
    emit(state.copyWith(
      status: OfficeSelectStateStatus.loading,
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
        status: OfficeSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: OfficeSelectStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onOfficeSelectEventPreviousPage(
      OfficeSelectEventPreviousPage event,
      Emitter<OfficeSelectState> emit) async {
    emit(
      state.copyWith(
        status: OfficeSelectStateStatus.loading,
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
        status: OfficeSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: OfficeSelectStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onOfficeSelectEventNextPage(
      OfficeSelectEventNextPage event, Emitter<OfficeSelectState> emit) async {
    emit(
      state.copyWith(status: OfficeSelectStateStatus.loading),
    );
    List<OfficeModel> listGet = await _repository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: OfficeSelectStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: OfficeSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onOfficeSelectEventFormSubmitted(
      OfficeSelectEventFormSubmitted event, Emitter<OfficeSelectState> emit) {
    if (event.name.isEmpty) {
      emit(state.copyWith(listFiltered: state.list));
    } else {
      List<OfficeModel> listTemp;
      listTemp = state.list.where((e) => e.name!.contains(event.name)).toList();
      emit(state.copyWith(listFiltered: listTemp));
    }
  }

  FutureOr<void> _onOfficeSelectEventUpdateSelectedValues(
      OfficeSelectEventUpdateSelectedValues event,
      Emitter<OfficeSelectState> emit) {
    int index =
        state.selectedValues.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<OfficeModel> temp = [...state.selectedValues];
      temp.removeAt(index);
      emit(state.copyWith(selectedValues: temp));
    } else {
      List<OfficeModel> temp = [...state.selectedValues];
      temp.add(event.model);
      emit(state.copyWith(selectedValues: temp));
    }
  }
}
