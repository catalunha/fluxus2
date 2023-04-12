import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/region_model.dart';
import '../../../../core/repositories/region_repository.dart';
import '../../../../data/b4a/entity/region_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'region_search_event.dart';
import 'region_search_state.dart';

class RegionSearchBloc extends Bloc<RegionSearchEvent, RegionSearchState> {
  final RegionRepository _regionRepository;
  RegionSearchBloc({
    required RegionRepository regionRepository,
  })  : _regionRepository = regionRepository,
        super(RegionSearchState.initial()) {
    on<RegionSearchEventFormSubmitted>(_onRegionSearchEventFormSubmitted);
    on<RegionSearchEventPreviousPage>(_onRegionSearchEventPreviousPage);
    on<RegionSearchEventNextPage>(_onUserProfileSearchEventNextPage);
    on<RegionSearchEventUpdateList>(_onRegionSearchEventUpdateList);
    on<RegionSearchEventRemoveFromList>(_onRegionSearchEventRemoveFromList);
  }

  FutureOr<void> _onRegionSearchEventFormSubmitted(
      RegionSearchEventFormSubmitted event,
      Emitter<RegionSearchState> emit) async {
    emit(state.copyWith(
      status: RegionSearchStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(RegionEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(RegionEntity.className));

      if (event.ufContainsBool) {
        query.whereContains(RegionEntity.uf, event.ufContainsString);
      }
      if (event.cityContainsBool) {
        query.whereContains(RegionEntity.city, event.cityContainsString);
      }
      if (event.nameContainsBool) {
        query.whereContains(RegionEntity.name, event.nameContainsString);
      }

      query.orderByAscending('name');
      List<RegionModel> regionModelListGet = await _regionRepository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: RegionSearchStateStatus.success,
        list: regionModelListGet,
        query: query,
      ));
    } catch (e) {
      print(e);
      emit(
        state.copyWith(
            status: RegionSearchStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onRegionSearchEventPreviousPage(
      RegionSearchEventPreviousPage event,
      Emitter<RegionSearchState> emit) async {
    emit(
      state.copyWith(
        status: RegionSearchStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<RegionModel> regionModelListGet = await _regionRepository.list(
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
        status: RegionSearchStateStatus.success,
        list: regionModelListGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: RegionSearchStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileSearchEventNextPage(
      RegionSearchEventNextPage event, Emitter<RegionSearchState> emit) async {
    emit(
      state.copyWith(status: RegionSearchStateStatus.loading),
    );
    List<RegionModel> regionModelListGet = await _regionRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (regionModelListGet.isEmpty) {
      emit(state.copyWith(
        status: RegionSearchStateStatus.success,
        // firstPage: false,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: RegionSearchStateStatus.success,
        list: regionModelListGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onRegionSearchEventUpdateList(
      RegionSearchEventUpdateList event, Emitter<RegionSearchState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<RegionModel> regionModelListTemp = [...state.list];
      regionModelListTemp.replaceRange(index, index + 1, [event.model]);
      emit(state.copyWith(list: regionModelListTemp));
    }
  }

  FutureOr<void> _onRegionSearchEventRemoveFromList(
      RegionSearchEventRemoveFromList event, Emitter<RegionSearchState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.modelId);
    if (index >= 0) {
      List<RegionModel> regionModelListTemp = [...state.list];
      regionModelListTemp.removeAt(index);
      emit(state.copyWith(list: regionModelListTemp));
    }
  }
}
