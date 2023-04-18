import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/event_model.dart';
import '../../../../core/repositories/event_repository.dart';
import '../../../../data/b4a/entity/event_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'event_select_event.dart';
import 'event_select_state.dart';

class EventSelectBloc extends Bloc<EventSelectEvent, EventSelectState> {
  final EventRepository _repository;
  EventSelectBloc({
    required EventRepository repository,
    required bool isSingleValue,
  })  : _repository = repository,
        super(EventSelectState.initial(isSingleValue)) {
    on<EventSelectEventStartQuery>(_onEventSelectEventStartQuery);
    on<EventSelectEventPreviousPage>(_onEventSelectEventPreviousPage);
    on<EventSelectEventNextPage>(_onEventSelectEventNextPage);
    on<EventSelectEventFormSubmitted>(_onEventSelectEventFormSubmitted);
    on<EventSelectEventUpdateSelectedValues>(
        _onEventSelectEventUpdateSelectedValues);
    add(EventSelectEventStartQuery());
  }

  FutureOr<void> _onEventSelectEventStartQuery(
      EventSelectEventStartQuery event, Emitter<EventSelectState> emit) async {
    emit(state.copyWith(
      status: EventSelectStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(EventEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(EventEntity.className));

      query.orderByDescending('updatedAt');
      List<EventModel> listGet = await _repository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: EventSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: EventSelectStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onEventSelectEventPreviousPage(
      EventSelectEventPreviousPage event,
      Emitter<EventSelectState> emit) async {
    emit(
      state.copyWith(
        status: EventSelectStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<EventModel> listGet = await _repository.list(
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
        status: EventSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: EventSelectStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onEventSelectEventNextPage(
      EventSelectEventNextPage event, Emitter<EventSelectState> emit) async {
    emit(
      state.copyWith(status: EventSelectStateStatus.loading),
    );
    List<EventModel> listGet = await _repository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: EventSelectStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: EventSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onEventSelectEventFormSubmitted(
      EventSelectEventFormSubmitted event, Emitter<EventSelectState> emit) {
    if (event.id.isEmpty) {
      emit(state.copyWith(listFiltered: state.list));
    } else {
      List<EventModel> listTemp;
      listTemp = state.list.where((e) => e.id!.contains(event.id)).toList();
      emit(state.copyWith(listFiltered: listTemp));
    }
  }

  FutureOr<void> _onEventSelectEventUpdateSelectedValues(
      EventSelectEventUpdateSelectedValues event,
      Emitter<EventSelectState> emit) {
    int index =
        state.selectedValues.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<EventModel> temp = [...state.selectedValues];
      temp.removeAt(index);
      emit(state.copyWith(selectedValues: temp));
    } else {
      List<EventModel> temp = [...state.selectedValues];
      temp.add(event.model);
      emit(state.copyWith(selectedValues: temp));
    }
  }
}
