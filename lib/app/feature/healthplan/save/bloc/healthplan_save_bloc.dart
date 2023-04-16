import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/healthplan_model.dart';
import '../../../../core/repositories/healthplan_repository.dart';
import 'healthplan_save_event.dart';
import 'healthplan_save_state.dart';

class HealthPlanSaveBloc
    extends Bloc<HealthPlanSaveEvent, HealthPlanSaveState> {
  final HealthPlanRepository _repository;
  HealthPlanSaveBloc({
    required HealthPlanModel? model,
    required HealthPlanRepository repository,
  })  : _repository = repository,
        super(HealthPlanSaveState.initial(model)) {
    on<HealthPlanSaveEventFormSubmitted>(_onHealthPlanSaveEventFormSubmitted);
    on<HealthPlanSaveEventDelete>(_onHealthPlanSaveEventDelete);
    on<HealthPlanSaveEventAddHealthPlanType>(
        _onHealthPlanSaveEventAddHealthPlanType);
  }

  FutureOr<void> _onHealthPlanSaveEventFormSubmitted(
      HealthPlanSaveEventFormSubmitted event,
      Emitter<HealthPlanSaveState> emit) async {
    emit(state.copyWith(status: HealthPlanSaveStateStatus.loading));
    try {
      HealthPlanModel model;
      if (state.model == null) {
        model = HealthPlanModel(
          code: event.code,
          due: event.due,
          description: event.description,
          healthPlanType: state.healthPlanType,
        );
      } else {
        model = state.model!.copyWith(
          code: event.code,
          due: event.due,
          description: event.description,
          healthPlanType: state.healthPlanType,
        );
      }
      String modelId = await _repository.update(model);

      model = model.copyWith(id: modelId);

      emit(state.copyWith(
          model: model, status: HealthPlanSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: HealthPlanSaveStateStatus.error,
          error: 'Erro ao salvar plano de saude'));
    }
  }

  FutureOr<void> _onHealthPlanSaveEventDelete(HealthPlanSaveEventDelete event,
      Emitter<HealthPlanSaveState> emit) async {
    try {
      emit(state.copyWith(status: HealthPlanSaveStateStatus.loading));
      await _repository.delete(state.model!.id!);
      emit(state.copyWith(status: HealthPlanSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: HealthPlanSaveStateStatus.error,
          error: 'Erro ao deletar  plano de saude'));
    }
  }

  FutureOr<void> _onHealthPlanSaveEventAddHealthPlanType(
      HealthPlanSaveEventAddHealthPlanType event,
      Emitter<HealthPlanSaveState> emit) {
    emit(state.copyWith(healthPlanType: event.model));
  }
}
