import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/expertise_model.dart';
import '../../../../core/repositories/expertise_repository.dart';
import 'expertise_save_event.dart';
import 'expertise_save_state.dart';

class ExpertiseSaveBloc extends Bloc<ExpertiseSaveEvent, ExpertiseSaveState> {
  final ExpertiseRepository _repository;
  ExpertiseSaveBloc({
    required ExpertiseModel? model,
    required ExpertiseRepository repository,
  })  : _repository = repository,
        super(ExpertiseSaveState.initial(model)) {
    on<ExpertiseSaveEventFormSubmitted>(_onExpertiseSaveEventFormSubmitted);
    on<ExpertiseSaveEventDelete>(_onExpertiseSaveEventDelete);
  }

  FutureOr<void> _onExpertiseSaveEventFormSubmitted(
      ExpertiseSaveEventFormSubmitted event,
      Emitter<ExpertiseSaveState> emit) async {
    emit(state.copyWith(status: ExpertiseSaveStateStatus.loading));
    try {
      ExpertiseModel model;
      if (state.model == null) {
        model = ExpertiseModel(
          name: event.name,
        );
      } else {
        model = state.model!.copyWith(
          name: event.name,
        );
      }
      String modelId = await _repository.update(model);

      model = model.copyWith(id: modelId);

      emit(state.copyWith(
          model: model, status: ExpertiseSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: ExpertiseSaveStateStatus.error,
          error: 'Erro ao salvar cycle'));
    }
  }

  FutureOr<void> _onExpertiseSaveEventDelete(
      ExpertiseSaveEventDelete event, Emitter<ExpertiseSaveState> emit) async {
    try {
      emit(state.copyWith(status: ExpertiseSaveStateStatus.loading));
      await _repository.delete(state.model!.id!);
      emit(state.copyWith(status: ExpertiseSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: ExpertiseSaveStateStatus.error,
          error: 'Erro ao delete item'));
    }
  }
}
