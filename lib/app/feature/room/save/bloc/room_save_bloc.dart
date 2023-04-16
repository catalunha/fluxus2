import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/room_model.dart';
import '../../../../core/repositories/room_repository.dart';
import 'room_save_event.dart';
import 'room_save_state.dart';

class RoomSaveBloc extends Bloc<RoomSaveEvent, RoomSaveState> {
  final RoomRepository _repository;
  RoomSaveBloc({
    required RoomModel? model,
    required RoomRepository repository,
  })  : _repository = repository,
        super(RoomSaveState.initial(model)) {
    on<RoomSaveEventFormSubmitted>(_onRoomSaveEventFormSubmitted);
    on<RoomSaveEventDelete>(_onRoomSaveEventDelete);
  }

  FutureOr<void> _onRoomSaveEventFormSubmitted(
      RoomSaveEventFormSubmitted event, Emitter<RoomSaveState> emit) async {
    emit(state.copyWith(status: RoomSaveStateStatus.loading));
    try {
      RoomModel model;
      if (state.model == null) {
        model = RoomModel(
          name: event.name,
        );
      } else {
        model = state.model!.copyWith(
          name: event.name,
        );
      }
      String modelId = await _repository.update(model);

      model = model.copyWith(id: modelId);

      emit(state.copyWith(model: model, status: RoomSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: RoomSaveStateStatus.error, error: 'Erro ao salvar cycle'));
    }
  }

  FutureOr<void> _onRoomSaveEventDelete(
      RoomSaveEventDelete event, Emitter<RoomSaveState> emit) async {
    try {
      emit(state.copyWith(status: RoomSaveStateStatus.loading));
      await _repository.delete(state.model!.id!);
      emit(state.copyWith(status: RoomSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: RoomSaveStateStatus.error, error: 'Erro ao delete item'));
    }
  }
}
