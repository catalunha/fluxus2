import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/office_model.dart';
import '../../../../core/repositories/office_repository.dart';
import 'office_save_event.dart';
import 'office_save_state.dart';

class OfficeSaveBloc extends Bloc<OfficeSaveEvent, OfficeSaveState> {
  final OfficeRepository _repository;
  OfficeSaveBloc({
    required OfficeModel? model,
    required OfficeRepository repository,
  })  : _repository = repository,
        super(OfficeSaveState.initial(model)) {
    on<OfficeSaveEventFormSubmitted>(_onOfficeSaveEventFormSubmitted);
    on<OfficeSaveEventDelete>(_onOfficeSaveEventDelete);
  }

  FutureOr<void> _onOfficeSaveEventFormSubmitted(
      OfficeSaveEventFormSubmitted event, Emitter<OfficeSaveState> emit) async {
    emit(state.copyWith(status: OfficeSaveStateStatus.loading));
    try {
      OfficeModel model;
      if (state.model == null) {
        model = OfficeModel(
          name: event.name,
        );
      } else {
        model = state.model!.copyWith(
          name: event.name,
        );
      }
      String modelId = await _repository.update(model);

      model = model.copyWith(id: modelId);

      emit(state.copyWith(model: model, status: OfficeSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: OfficeSaveStateStatus.error, error: 'Erro ao salvar cycle'));
    }
  }

  FutureOr<void> _onOfficeSaveEventDelete(
      OfficeSaveEventDelete event, Emitter<OfficeSaveState> emit) async {
    try {
      emit(state.copyWith(status: OfficeSaveStateStatus.loading));
      await _repository.delete(state.model!.id!);
      emit(state.copyWith(status: OfficeSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: OfficeSaveStateStatus.error, error: 'Erro ao delete item'));
    }
  }
}
