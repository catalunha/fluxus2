import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/graduation_model.dart';
import '../../../../core/repositories/graduation_repository.dart';
import '../../../../data/b4a/entity/graduation_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'graduation_list_event.dart';
import 'graduation_list_state.dart';

class GraduationListBloc
    extends Bloc<GraduationListEvent, GraduationListState> {
  final GraduationRepository _repository;
  GraduationListBloc({
    required GraduationRepository repository,
  })  : _repository = repository,
        super(GraduationListState.initial()) {
    on<GraduationListEventInitialList>(_onGraduationListEventInitial);
    on<GraduationListEventPreviousPage>(_onGraduationListEventPreviousPage);
    on<GraduationListEventNextPage>(_onUserProfileListEventNextPage);
    on<GraduationListEventUpdateList>(_onGraduationListEventUpdateList);
    on<GraduationListEventRemoveFromList>(_onGraduationListEventRemoveFromList);
    add(GraduationListEventInitialList());
  }

  FutureOr<void> _onGraduationListEventInitial(
      GraduationListEventInitialList event,
      Emitter<GraduationListState> emit) async {
    emit(state.copyWith(
      status: GraduationListStateStatus.loading,
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
        status: GraduationListStateStatus.success,
        list: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: GraduationListStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onGraduationListEventPreviousPage(
      GraduationListEventPreviousPage event,
      Emitter<GraduationListState> emit) async {
    emit(
      state.copyWith(
        status: GraduationListStateStatus.loading,
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
        status: GraduationListStateStatus.success,
        list: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: GraduationListStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileListEventNextPage(
      GraduationListEventNextPage event,
      Emitter<GraduationListState> emit) async {
    emit(
      state.copyWith(status: GraduationListStateStatus.loading),
    );
    List<GraduationModel> listGet = await _repository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: GraduationListStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: GraduationListStateStatus.success,
        list: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onGraduationListEventUpdateList(
      GraduationListEventUpdateList event, Emitter<GraduationListState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<GraduationModel> listTemp = [...state.list];
      listTemp.replaceRange(index, index + 1, [event.model]);
      emit(state.copyWith(list: listTemp));
    }
  }

  FutureOr<void> _onGraduationListEventRemoveFromList(
      GraduationListEventRemoveFromList event,
      Emitter<GraduationListState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.id);
    if (index >= 0) {
      List<GraduationModel> listTemp = [...state.list];
      listTemp.removeAt(index);
      emit(state.copyWith(list: listTemp));
    }
  }
}
