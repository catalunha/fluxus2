import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/graduation_model.dart';
import '../../../../core/repositories/graduation_repository.dart';
import 'graduation_save_event.dart';
import 'graduation_save_state.dart';

class GraduationSaveBloc
    extends Bloc<GraduationSaveEvent, GraduationSaveState> {
  final GraduationRepository _repository;
  GraduationSaveBloc({
    required GraduationModel? model,
    required GraduationRepository repository,
  })  : _repository = repository,
        super(GraduationSaveState.initial(model)) {
    on<GraduationSaveEventFormSubmitted>(_onGraduationSaveEventFormSubmitted);
    on<GraduationSaveEventDelete>(_onGraduationSaveEventDelete);
  }

  FutureOr<void> _onGraduationSaveEventFormSubmitted(
      GraduationSaveEventFormSubmitted event,
      Emitter<GraduationSaveState> emit) async {
    emit(state.copyWith(status: GraduationSaveStateStatus.loading));
    try {
      GraduationModel model;
      if (state.model == null) {
        model = GraduationModel(
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
          model: model, status: GraduationSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: GraduationSaveStateStatus.error,
          error: 'Erro ao salvar cycle'));
    }
  }

  FutureOr<void> _onGraduationSaveEventDelete(GraduationSaveEventDelete event,
      Emitter<GraduationSaveState> emit) async {
    try {
      emit(state.copyWith(status: GraduationSaveStateStatus.loading));
      await _repository.delete(state.model!.id!);
      emit(state.copyWith(status: GraduationSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: GraduationSaveStateStatus.error,
          error: 'Erro ao delete item'));
    }
  }
}
