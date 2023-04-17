import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/Status_model.dart';
import '../../../../core/repositories/Status_repository.dart';
import 'Status_save_event.dart';
import 'Status_save_state.dart';

class StatusSaveBloc extends Bloc<StatusSaveEvent, StatusSaveState> {
  final StatusRepository _repository;
  StatusSaveBloc({
    required StatusModel? model,
    required StatusRepository repository,
  })  : _repository = repository,
        super(StatusSaveState.initial(model)) {
    on<StatusSaveEventFormSubmitted>(_onStatusSaveEventFormSubmitted);
    on<StatusSaveEventDelete>(_onStatusSaveEventDelete);
  }

  FutureOr<void> _onStatusSaveEventFormSubmitted(
      StatusSaveEventFormSubmitted event, Emitter<StatusSaveState> emit) async {
    emit(state.copyWith(status: StatusSaveStateStatus.loading));
    try {
      StatusModel model;
      if (state.model == null) {
        model = StatusModel(
          name: event.name,
        );
      } else {
        model = state.model!.copyWith(
          name: event.name,
        );
      }
      String modelId = await _repository.update(model);

      model = model.copyWith(id: modelId);

      emit(state.copyWith(model: model, status: StatusSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: StatusSaveStateStatus.error, error: 'Erro ao salvar cycle'));
    }
  }

  FutureOr<void> _onStatusSaveEventDelete(
      StatusSaveEventDelete event, Emitter<StatusSaveState> emit) async {
    try {
      emit(state.copyWith(status: StatusSaveStateStatus.loading));
      await _repository.delete(state.model!.id!);
      emit(state.copyWith(status: StatusSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: StatusSaveStateStatus.error, error: 'Erro ao delete item'));
    }
  }
}
