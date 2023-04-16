import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/room_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/room_repository.dart';
import '../../../../data/b4a/entity/room_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'room_select_event.dart';
import 'room_select_state.dart';

class RoomSelectBloc extends Bloc<RoomSelectEvent, RoomSelectState> {
  final RoomRepository _repository;
  RoomSelectBloc({
    required RoomRepository repository,
    required UserProfileModel seller,
    required bool isSingleValue,
  })  : _repository = repository,
        super(RoomSelectState.initial(isSingleValue)) {
    on<RoomSelectEventStartQuery>(_onRoomSelectEventStartQuery);
    on<RoomSelectEventPreviousPage>(_onRoomSelectEventPreviousPage);
    on<RoomSelectEventNextPage>(_onRoomSelectEventNextPage);
    on<RoomSelectEventFormSubmitted>(_onRoomSelectEventFormSubmitted);
    on<RoomSelectEventUpdateSelectedValues>(
        _onRoomSelectEventUpdateSelectedValues);

    add(RoomSelectEventStartQuery());
  }

  FutureOr<void> _onRoomSelectEventStartQuery(
      RoomSelectEventStartQuery event, Emitter<RoomSelectState> emit) async {
    emit(state.copyWith(
      status: RoomSelectStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(RoomEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(RoomEntity.className));

      query.orderByAscending('name');
      List<RoomModel> listGet = await _repository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: RoomSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: RoomSelectStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onRoomSelectEventPreviousPage(
      RoomSelectEventPreviousPage event, Emitter<RoomSelectState> emit) async {
    emit(
      state.copyWith(
        status: RoomSelectStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<RoomModel> listGet = await _repository.list(
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
        status: RoomSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: RoomSelectStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onRoomSelectEventNextPage(
      RoomSelectEventNextPage event, Emitter<RoomSelectState> emit) async {
    emit(
      state.copyWith(status: RoomSelectStateStatus.loading),
    );
    List<RoomModel> listGet = await _repository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: RoomSelectStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: RoomSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onRoomSelectEventFormSubmitted(
      RoomSelectEventFormSubmitted event, Emitter<RoomSelectState> emit) {
    if (event.name.isEmpty) {
      emit(state.copyWith(listFiltered: state.list));
    } else {
      List<RoomModel> listTemp;
      listTemp = state.list.where((e) => e.name!.contains(event.name)).toList();
      emit(state.copyWith(listFiltered: listTemp));
    }
  }

  FutureOr<void> _onRoomSelectEventUpdateSelectedValues(
      RoomSelectEventUpdateSelectedValues event,
      Emitter<RoomSelectState> emit) {
    int index =
        state.selectedValues.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<RoomModel> temp = [...state.selectedValues];
      temp.removeAt(index);
      emit(state.copyWith(selectedValues: temp));
    } else {
      List<RoomModel> temp = [...state.selectedValues];
      temp.add(event.model);
      emit(state.copyWith(selectedValues: temp));
    }
  }
}
