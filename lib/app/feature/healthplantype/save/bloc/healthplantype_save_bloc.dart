import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/healthplantype_model.dart';
import '../../../../core/repositories/healthplantype_repository.dart';
import 'healthplantype_save_event.dart';
import 'healthplantype_save_state.dart';

class HealthPlanTypeSaveBloc
    extends Bloc<HealthPlanTypeSaveEvent, HealthPlanTypeSaveState> {
  final HealthPlanTypeRepository _repository;
  HealthPlanTypeSaveBloc({
    required HealthPlanTypeModel? model,
    required HealthPlanTypeRepository repository,
  })  : _repository = repository,
        super(HealthPlanTypeSaveState.initial(model)) {
    on<HealthPlanTypeSaveEventFormSubmitted>(
        _onHealthPlanTypeSaveEventFormSubmitted);
    on<HealthPlanTypeSaveEventDelete>(_onHealthPlanTypeSaveEventDelete);
  }

  FutureOr<void> _onHealthPlanTypeSaveEventFormSubmitted(
      HealthPlanTypeSaveEventFormSubmitted event,
      Emitter<HealthPlanTypeSaveState> emit) async {
    emit(state.copyWith(status: HealthPlanTypeSaveStateStatus.loading));
    try {
      HealthPlanTypeModel model;
      if (state.model == null) {
        model = HealthPlanTypeModel(
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
          model: model, status: HealthPlanTypeSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: HealthPlanTypeSaveStateStatus.error,
          error: 'Erro ao salvar cycle'));
    }
  }

  FutureOr<void> _onHealthPlanTypeSaveEventDelete(
      HealthPlanTypeSaveEventDelete event,
      Emitter<HealthPlanTypeSaveState> emit) async {
    try {
      emit(state.copyWith(status: HealthPlanTypeSaveStateStatus.loading));
      await _repository.delete(state.model!.id!);
      emit(state.copyWith(status: HealthPlanTypeSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: HealthPlanTypeSaveStateStatus.error,
          error: 'Erro ao delete item'));
    }
  }
}
