import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/healthplantype_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/healthplantype_repository.dart';
import '../../../../data/b4a/entity/healthplantype_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'healthplantype_select_event.dart';
import 'healthplantype_select_state.dart';

class HealthPlanTypeSelectBloc
    extends Bloc<HealthPlanTypeSelectEvent, HealthPlanTypeSelectState> {
  final HealthPlanTypeRepository _repository;
  HealthPlanTypeSelectBloc({
    required HealthPlanTypeRepository repository,
    required UserProfileModel seller,
    required bool isSingleValue,
  })  : _repository = repository,
        super(HealthPlanTypeSelectState.initial(isSingleValue)) {
    on<HealthPlanTypeSelectEventStartQuery>(
        _onHealthPlanTypeSelectEventStartQuery);
    on<HealthPlanTypeSelectEventPreviousPage>(
        _onHealthPlanTypeSelectEventPreviousPage);
    on<HealthPlanTypeSelectEventNextPage>(_onHealthPlanTypeSelectEventNextPage);
    on<HealthPlanTypeSelectEventFormSubmitted>(
        _onHealthPlanTypeSelectEventFormSubmitted);
    on<HealthPlanTypeSelectEventUpdateSelectedValues>(
        _onHealthPlanTypeSelectEventUpdateSelectedValues);

    add(HealthPlanTypeSelectEventStartQuery());
  }

  FutureOr<void> _onHealthPlanTypeSelectEventStartQuery(
      HealthPlanTypeSelectEventStartQuery event,
      Emitter<HealthPlanTypeSelectState> emit) async {
    emit(state.copyWith(
      status: HealthPlanTypeSelectStateStatus.loading,
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
        status: HealthPlanTypeSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: HealthPlanTypeSelectStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onHealthPlanTypeSelectEventPreviousPage(
      HealthPlanTypeSelectEventPreviousPage event,
      Emitter<HealthPlanTypeSelectState> emit) async {
    emit(
      state.copyWith(
        status: HealthPlanTypeSelectStateStatus.loading,
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
        status: HealthPlanTypeSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: HealthPlanTypeSelectStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onHealthPlanTypeSelectEventNextPage(
      HealthPlanTypeSelectEventNextPage event,
      Emitter<HealthPlanTypeSelectState> emit) async {
    emit(
      state.copyWith(status: HealthPlanTypeSelectStateStatus.loading),
    );
    List<HealthPlanTypeModel> listGet = await _repository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: HealthPlanTypeSelectStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: HealthPlanTypeSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onHealthPlanTypeSelectEventFormSubmitted(
      HealthPlanTypeSelectEventFormSubmitted event,
      Emitter<HealthPlanTypeSelectState> emit) {
    if (event.name.isEmpty) {
      emit(state.copyWith(listFiltered: state.list));
    } else {
      List<HealthPlanTypeModel> listTemp;
      listTemp = state.list.where((e) => e.name!.contains(event.name)).toList();
      emit(state.copyWith(listFiltered: listTemp));
    }
  }

  FutureOr<void> _onHealthPlanTypeSelectEventUpdateSelectedValues(
      HealthPlanTypeSelectEventUpdateSelectedValues event,
      Emitter<HealthPlanTypeSelectState> emit) {
    int index =
        state.selectedValues.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<HealthPlanTypeModel> temp = [...state.selectedValues];
      temp.removeAt(index);
      emit(state.copyWith(selectedValues: temp));
    } else {
      List<HealthPlanTypeModel> temp = [...state.selectedValues];
      temp.add(event.model);
      emit(state.copyWith(selectedValues: temp));
    }
  }
}
