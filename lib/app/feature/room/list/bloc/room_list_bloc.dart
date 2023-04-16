import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/room_model.dart';
import '../../../../core/repositories/room_repository.dart';
import '../../../../data/b4a/entity/room_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'room_list_event.dart';
import 'room_list_state.dart';

class RoomListBloc extends Bloc<RoomListEvent, RoomListState> {
  final RoomRepository _repository;
  RoomListBloc({
    required RoomRepository repository,
  })  : _repository = repository,
        super(RoomListState.initial()) {
    on<RoomListEventInitialList>(_onRoomListEventInitial);
    on<RoomListEventPreviousPage>(_onRoomListEventPreviousPage);
    on<RoomListEventNextPage>(_onUserProfileListEventNextPage);
    on<RoomListEventAddToList>(_onRoomListEventAddToList);
    on<RoomListEventUpdateList>(_onRoomListEventUpdateList);
    on<RoomListEventRemoveFromList>(_onRoomListEventRemoveFromList);
    add(RoomListEventInitialList());
  }

  FutureOr<void> _onRoomListEventInitial(
      RoomListEventInitialList event, Emitter<RoomListState> emit) async {
    emit(state.copyWith(
      status: RoomListStateStatus.loading,
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
        status: RoomListStateStatus.success,
        list: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: RoomListStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onRoomListEventPreviousPage(
      RoomListEventPreviousPage event, Emitter<RoomListState> emit) async {
    emit(
      state.copyWith(
        status: RoomListStateStatus.loading,
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
        status: RoomListStateStatus.success,
        list: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: RoomListStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileListEventNextPage(
      RoomListEventNextPage event, Emitter<RoomListState> emit) async {
    emit(
      state.copyWith(status: RoomListStateStatus.loading),
    );
    List<RoomModel> listGet = await _repository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: RoomListStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: RoomListStateStatus.success,
        list: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onRoomListEventAddToList(
      RoomListEventAddToList event, Emitter<RoomListState> emit) {
    List<RoomModel> listTemp = [...state.list];
    listTemp.add(event.model);
    emit(state.copyWith(list: listTemp));
  }

  FutureOr<void> _onRoomListEventUpdateList(
      RoomListEventUpdateList event, Emitter<RoomListState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<RoomModel> listTemp = [...state.list];
      listTemp.replaceRange(index, index + 1, [event.model]);
      emit(state.copyWith(list: listTemp));
    }
  }

  FutureOr<void> _onRoomListEventRemoveFromList(
      RoomListEventRemoveFromList event, Emitter<RoomListState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.id);
    if (index >= 0) {
      List<RoomModel> listTemp = [...state.list];
      listTemp.removeAt(index);
      emit(state.copyWith(list: listTemp));
    }
  }
}
