import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/expertise_repository.dart';
import '../../../../data/b4a/entity/expertise_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'expertise_select_event.dart';
import 'expertise_select_state.dart';

class ExpertiseSelectBloc
    extends Bloc<ExpertiseSelectEvent, ExpertiseSelectState> {
  final ExpertiseRepository _repository;
  ExpertiseSelectBloc({
    required ExpertiseRepository repository,
    required UserProfileModel seller,
    required bool isSingleValue,
  })  : _repository = repository,
        super(ExpertiseSelectState.initial(isSingleValue)) {
    on<ExpertiseSelectEventStartQuery>(_onExpertiseSelectEventStartQuery);
    on<ExpertiseSelectEventPreviousPage>(_onExpertiseSelectEventPreviousPage);
    on<ExpertiseSelectEventNextPage>(_onExpertiseSelectEventNextPage);
    on<ExpertiseSelectEventFormSubmitted>(_onExpertiseSelectEventFormSubmitted);
    on<ExpertiseSelectEventUpdateSelectedValues>(
        _onExpertiseSelectEventUpdateSelectedValues);
    add(ExpertiseSelectEventStartQuery());
  }

  FutureOr<void> _onExpertiseSelectEventStartQuery(
      ExpertiseSelectEventStartQuery event,
      Emitter<ExpertiseSelectState> emit) async {
    emit(state.copyWith(
      status: ExpertiseSelectStateStatus.loading,
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
        ExpertiseEntity.singleCols,
      );

      emit(state.copyWith(
        status: ExpertiseSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: ExpertiseSelectStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onExpertiseSelectEventPreviousPage(
      ExpertiseSelectEventPreviousPage event,
      Emitter<ExpertiseSelectState> emit) async {
    emit(
      state.copyWith(
        status: ExpertiseSelectStateStatus.loading,
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
        status: ExpertiseSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: ExpertiseSelectStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onExpertiseSelectEventNextPage(
      ExpertiseSelectEventNextPage event,
      Emitter<ExpertiseSelectState> emit) async {
    emit(
      state.copyWith(status: ExpertiseSelectStateStatus.loading),
    );
    List<ExpertiseModel> listGet = await _repository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: ExpertiseSelectStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: ExpertiseSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onExpertiseSelectEventFormSubmitted(
      ExpertiseSelectEventFormSubmitted event,
      Emitter<ExpertiseSelectState> emit) {
    if (event.name.isEmpty) {
      emit(state.copyWith(listFiltered: state.list));
    } else {
      List<ExpertiseModel> listTemp;
      listTemp = state.list.where((e) => e.name!.contains(event.name)).toList();
      emit(state.copyWith(listFiltered: listTemp));
    }
  }

  FutureOr<void> _onExpertiseSelectEventUpdateSelectedValues(
      ExpertiseSelectEventUpdateSelectedValues event,
      Emitter<ExpertiseSelectState> emit) {
    int index =
        state.selectedValues.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<ExpertiseModel> temp = [...state.selectedValues];
      temp.removeAt(index);
      emit(state.copyWith(selectedValues: temp));
    } else {
      List<ExpertiseModel> temp = [...state.selectedValues];
      temp.add(event.model);
      emit(state.copyWith(selectedValues: temp));
    }
  }
}
