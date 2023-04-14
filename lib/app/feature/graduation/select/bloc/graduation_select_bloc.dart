import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/graduation_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/graduation_repository.dart';
import '../../../../data/b4a/entity/graduation_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'graduation_select_event.dart';
import 'graduation_select_state.dart';

class GraduationSelectBloc
    extends Bloc<GraduationSelectEvent, GraduationSelectState> {
  final GraduationRepository _repository;
  GraduationSelectBloc({
    required GraduationRepository repository,
    required UserProfileModel seller,
    required bool isSingleValue,
  })  : _repository = repository,
        super(GraduationSelectState.initial(isSingleValue)) {
    on<GraduationSelectEventStartQuery>(_onGraduationSelectEventStartQuery);
    on<GraduationSelectEventPreviousPage>(_onGraduationSelectEventPreviousPage);
    on<GraduationSelectEventNextPage>(_onGraduationSelectEventNextPage);
    on<GraduationSelectEventFormSubmitted>(
        _onGraduationSelectEventFormSubmitted);
    on<GraduationSelectEventUpdateSelectedValues>(
        _onGraduationSelectEventUpdateSelectedValues);
    // on<GraduationSelectEventRemoveSelected>(
    //     _onGraduationSelectEventRemoveSelected);
    add(GraduationSelectEventStartQuery());
  }

  FutureOr<void> _onGraduationSelectEventStartQuery(
      GraduationSelectEventStartQuery event,
      Emitter<GraduationSelectState> emit) async {
    emit(state.copyWith(
      status: GraduationSelectStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(GraduationEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(GraduationEntity.className));

      query.orderByAscending('name');
      List<GraduationModel> listGet = await _repository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: GraduationSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: GraduationSelectStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onGraduationSelectEventPreviousPage(
      GraduationSelectEventPreviousPage event,
      Emitter<GraduationSelectState> emit) async {
    emit(
      state.copyWith(
        status: GraduationSelectStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<GraduationModel> listGet = await _repository.list(
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
        status: GraduationSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: GraduationSelectStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onGraduationSelectEventNextPage(
      GraduationSelectEventNextPage event,
      Emitter<GraduationSelectState> emit) async {
    emit(
      state.copyWith(status: GraduationSelectStateStatus.loading),
    );
    List<GraduationModel> listGet = await _repository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: GraduationSelectStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: GraduationSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onGraduationSelectEventFormSubmitted(
      GraduationSelectEventFormSubmitted event,
      Emitter<GraduationSelectState> emit) {
    if (event.name.isEmpty) {
      emit(state.copyWith(listFiltered: state.list));
    } else {
      List<GraduationModel> listTemp;
      listTemp = state.list.where((e) => e.name!.contains(event.name)).toList();
      emit(state.copyWith(listFiltered: listTemp));
    }
  }

  FutureOr<void> _onGraduationSelectEventUpdateSelectedValues(
      GraduationSelectEventUpdateSelectedValues event,
      Emitter<GraduationSelectState> emit) {
    int index =
        state.selectedValues.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<GraduationModel> temp = [...state.selectedValues];
      temp.removeAt(index);
      emit(state.copyWith(selectedValues: temp));
    } else {
      List<GraduationModel> temp = [...state.selectedValues];
      temp.add(event.model);
      emit(state.copyWith(selectedValues: temp));
    }
  }

  // FutureOr<void> _onGraduationSelectEventRemoveSelected(
  //     GraduationSelectEventRemoveSelected event,
  //     Emitter<GraduationSelectState> emit) {}
}
