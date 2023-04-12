import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/region_model.dart';
import '../../../../core/repositories/region_repository.dart';
import 'region_save_event.dart';
import 'region_save_state.dart';

class RegionSaveBloc extends Bloc<RegionSaveEvent, RegionSaveState> {
  final RegionRepository _regionRepository;
  RegionSaveBloc({
    required RegionModel? regionModel,
    required RegionRepository regionRepository,
  })  : _regionRepository = regionRepository,
        super(RegionSaveState.initial(regionModel)) {
    on<RegionSaveEventFormSubmitted>(_onRegionSaveEventFormSubmitted);
    on<RegionSaveEventDelete>(_onRegionSaveEventDelete);
  }

  FutureOr<void> _onRegionSaveEventFormSubmitted(
      RegionSaveEventFormSubmitted event, Emitter<RegionSaveState> emit) async {
    emit(state.copyWith(status: RegionSaveStateStatus.loading));
    try {
      RegionModel regionModel;
      if (state.model == null) {
        regionModel = RegionModel(
          uf: event.uf,
          city: event.city,
          name: event.name,
        );
      } else {
        regionModel = state.model!.copyWith(
          uf: event.uf,
          city: event.city,
          name: event.name,
        );
      }
      String regionModelId = await _regionRepository.update(regionModel);

      regionModel = regionModel.copyWith(id: regionModelId);

      emit(state.copyWith(
          model: regionModel, status: RegionSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: RegionSaveStateStatus.error, error: 'Erro ao salvar region'));
    }
  }

  FutureOr<void> _onRegionSaveEventDelete(
      RegionSaveEventDelete event, Emitter<RegionSaveState> emit) async {
    try {
      emit(state.copyWith(status: RegionSaveStateStatus.loading));
      await _regionRepository.delete(state.model!.id!);
      emit(state.copyWith(status: RegionSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: RegionSaveStateStatus.error, error: 'Erro ao salvar region'));
    }
  }
}
