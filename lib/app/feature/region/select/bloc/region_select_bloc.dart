import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/region_model.dart';
import '../../../../core/repositories/region_repository.dart';
import '../../../../data/b4a/entity/region_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'region_select_event.dart';
import 'region_select_state.dart';

class RegionSelectBloc extends Bloc<RegionSelectEvent, RegionSelectState> {
  final RegionRepository _regionRepository;
  RegionSelectBloc({required RegionRepository regionRepository})
      : _regionRepository = regionRepository,
        super(RegionSelectState.initial()) {
    on<RegionSelectEventStartQuery>(_onRegionSelectEventStartQuery);
    on<RegionSelectEventPreviousPage>(_onRegionSelectEventPreviousPage);
    on<RegionSelectEventNextPage>(_onRegionSelectEventNextPage);
    on<RegionSelectEventFormSubmitted>(_onRegionSelectEventFormSubmitted);
    add(RegionSelectEventStartQuery());
  }

  FutureOr<void> _onRegionSelectEventStartQuery(
      RegionSelectEventStartQuery event,
      Emitter<RegionSelectState> emit) async {
    emit(state.copyWith(
      status: RegionSelectStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(RegionEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(RegionEntity.className));

      query.orderByAscending('name');
      List<RegionModel> listGet = await _regionRepository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: RegionSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: RegionSelectStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onRegionSelectEventPreviousPage(
      RegionSelectEventPreviousPage event,
      Emitter<RegionSelectState> emit) async {
    emit(
      state.copyWith(
        status: RegionSelectStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<RegionModel> listGet = await _regionRepository.list(
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
        status: RegionSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: RegionSelectStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onRegionSelectEventNextPage(
      RegionSelectEventNextPage event, Emitter<RegionSelectState> emit) async {
    emit(
      state.copyWith(status: RegionSelectStateStatus.loading),
    );
    List<RegionModel> listGet = await _regionRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: RegionSelectStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: RegionSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onRegionSelectEventFormSubmitted(
      RegionSelectEventFormSubmitted event, Emitter<RegionSelectState> emit) {
    if (event.name.isEmpty) {
      emit(state.copyWith(listFiltered: state.list));
    } else {
      List<RegionModel> listTemp;
      listTemp = state.list.where((e) => e.name!.contains(event.name)).toList();
      emit(state.copyWith(listFiltered: listTemp));
    }
  }
}
