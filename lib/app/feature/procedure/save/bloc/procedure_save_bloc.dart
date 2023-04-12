import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/procedure_model.dart';
import '../../../../core/repositories/procedure_repository.dart';
import 'procedure_save_event.dart';
import 'procedure_save_state.dart';

class ProcedureSaveBloc extends Bloc<ProcedureSaveEvent, ProcedureSaveState> {
  final ProcedureRepository _repository;
  ProcedureSaveBloc({
    required ProcedureModel? model,
    required ProcedureRepository repository,
  })  : _repository = repository,
        super(ProcedureSaveState.initial(model)) {
    on<ProcedureSaveEventFormSubmitted>(_onProcedureSaveEventFormSubmitted);
    on<ProcedureSaveEventDelete>(_onProcedureSaveEventDelete);
    on<ProcedureSaveEventAddExpertise>(_onProcedureSaveEventAddExpertise);
  }

  FutureOr<void> _onProcedureSaveEventFormSubmitted(
      ProcedureSaveEventFormSubmitted event,
      Emitter<ProcedureSaveState> emit) async {
    emit(state.copyWith(status: ProcedureSaveStateStatus.loading));
    try {
      ProcedureModel model;
      if (state.model == null) {
        model = ProcedureModel(
          name: event.name,
          code: event.code,
          cost: event.cost,
          expertise: state.expertise,
        );
      } else {
        model = state.model!.copyWith(
          name: event.name,
          code: event.code,
          cost: event.cost,
          expertise: state.expertise,
        );
      }
      String modelId = await _repository.update(model);

      model = model.copyWith(id: modelId);

      emit(state.copyWith(
          model: model, status: ProcedureSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: ProcedureSaveStateStatus.error,
          error: 'Erro ao salvar procedure'));
    }
  }

  FutureOr<void> _onProcedureSaveEventDelete(
      ProcedureSaveEventDelete event, Emitter<ProcedureSaveState> emit) async {
    try {
      emit(state.copyWith(status: ProcedureSaveStateStatus.loading));
      await _repository.delete(state.model!.id!);
      emit(state.copyWith(status: ProcedureSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: ProcedureSaveStateStatus.error,
          error: 'Erro ao deletar procedure'));
    }
  }

  FutureOr<void> _onProcedureSaveEventAddExpertise(
      ProcedureSaveEventAddExpertise event, Emitter<ProcedureSaveState> emit) {
    emit(state.copyWith(expertise: event.model));
  }
}
