import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/healthplan_model.dart';
import '../../../../core/models/patient_model.dart';
import '../../../../core/repositories/healthplan_repository.dart';
import '../../../../core/repositories/patient_repository.dart';
import 'patient_save_event.dart';
import 'patient_save_state.dart';

class PatientSaveBloc extends Bloc<PatientSaveEvent, PatientSaveState> {
  final PatientRepository _repository;
  final HealthPlanRepository _healthPlanRepository;
  PatientSaveBloc({
    required PatientModel? model,
    required PatientRepository repository,
    required HealthPlanRepository healthPlanRepository,
  })  : _repository = repository,
        _healthPlanRepository = healthPlanRepository,
        super(PatientSaveState.initial(model)) {
    on<PatientSaveEventFormSubmitted>(_onPatientSaveEventFormSubmitted);
    on<PatientSaveEventAddRegion>(_onPatientSaveEventAddRegion);
    on<PatientSaveEventAddFamily>(_onPatientSaveEventAddFamily);
    on<PatientSaveEventRemoveFamily>(_onPatientSaveEventRemoveFamily);
    on<PatientSaveEventAddHealthPlan>(_onPatientSaveEventAddHealthPlan);
    on<PatientSaveEventUpdateHealthPlan>(_onPatientSaveEventUpdateHealthPlan);
    on<PatientSaveEventRemoveHealthPlan>(_onPatientSaveEventRemoveHealthPlan);
  }

  FutureOr<void> _onPatientSaveEventFormSubmitted(
      PatientSaveEventFormSubmitted event,
      Emitter<PatientSaveState> emit) async {
    emit(state.copyWith(status: PatientSaveStateStatus.loading));
    try {
      PatientModel model;
      if (state.model == null) {
        model = state.model!.copyWith(
          nickname: event.nickname,
          name: event.name,
          cpf: event.cpf,
          phone: event.phone,
          address: event.address,
          isFemale: event.isFemale,
          birthday: event.birthday,
          region: state.region,
        );
      } else {
        model = state.model!.copyWith(
          nickname: event.nickname,
          name: event.name,
          cpf: event.cpf,
          phone: event.phone,
          address: event.address,
          isFemale: event.isFemale,
          birthday: event.birthday,
          region: state.region,
        );
      }
      String patientId = await _repository.update(model);
      List<PatientModel> familyResults = await updateRelationFamily(patientId);
      List<HealthPlanModel> healthPlansResults =
          await updateRelationHealthPlan(patientId);
      model = model.copyWith(
        id: patientId,
        family: familyResults,
        healthPlan: healthPlansResults,
      );

      emit(
          state.copyWith(model: model, status: PatientSaveStateStatus.success));
    } catch (_) {
      emit(state.copyWith(
          status: PatientSaveStateStatus.error,
          error: 'Erro ao salvar dados no seu perfil'));
    }
  }

  FutureOr<void> _onPatientSaveEventAddRegion(
      PatientSaveEventAddRegion event, Emitter<PatientSaveState> emit) {
    emit(state.copyWith(region: event.model));
  }

  FutureOr<void> _onPatientSaveEventAddFamily(
      PatientSaveEventAddFamily event, Emitter<PatientSaveState> emit) {
    int index =
        state.familyUpdated.indexWhere((model) => model.id == event.model.id);
    if (index < 0) {
      List<PatientModel> temp = [...state.familyUpdated];
      temp.add(event.model);
      emit(state.copyWith(familyUpdated: temp));
    }
  }

  FutureOr<void> _onPatientSaveEventRemoveFamily(
      PatientSaveEventRemoveFamily event, Emitter<PatientSaveState> emit) {
    List<PatientModel> temp = [...state.familyUpdated];
    temp.removeWhere((element) => element.id == event.model.id);
    emit(state.copyWith(familyUpdated: temp));
  }

  Future<List<PatientModel>> updateRelationFamily(String modelId) async {
    List<PatientModel> listResult = [];
    List<PatientModel> listFinal = [];
    listResult.addAll([...state.familyUpdated]);
    listFinal.addAll([...state.familyOriginal]);
    for (var original in state.familyOriginal) {
      int index =
          state.familyUpdated.indexWhere((model) => model.id == original.id);
      if (index < 0) {
        await _repository.updateRelationFamily(modelId, [original.id!], false);
        listFinal.removeWhere((element) => element.id == original.id);
      } else {
        listResult.removeWhere((element) => element.id == original.id);
      }
    }
    for (var result in listResult) {
      await _repository.updateRelationFamily(modelId, [result.id!], true);
      listFinal.add(result);
    }
    return listFinal;
  }

  FutureOr<void> _onPatientSaveEventAddHealthPlan(
      PatientSaveEventAddHealthPlan event,
      Emitter<PatientSaveState> emit) async {
    emit(state.copyWith(status: PatientSaveStateStatus.loading));
    try {
      HealthPlanModel healthPlanTemp = event.model.copyWith();
      String healthPlanTempId =
          await _healthPlanRepository.update(healthPlanTemp);
      healthPlanTemp = event.model.copyWith(id: healthPlanTempId);
      List<HealthPlanModel> temp = [...state.healthPlansUpdated];
      temp.add(healthPlanTemp);
      emit(state.copyWith(
        healthPlansUpdated: temp,
        status: PatientSaveStateStatus.updated,
      ));
    } catch (_) {
      emit(state.copyWith(
          status: PatientSaveStateStatus.error,
          error: 'Erro ao salvar plano de saude'));
    }
  }

  FutureOr<void> _onPatientSaveEventUpdateHealthPlan(
      PatientSaveEventUpdateHealthPlan event,
      Emitter<PatientSaveState> emit) async {
    emit(state.copyWith(status: PatientSaveStateStatus.loading));
    try {
      HealthPlanModel healthPlanTemp = event.model.copyWith();
      await _healthPlanRepository.update(healthPlanTemp);
      int index = state.healthPlansUpdated
          .indexWhere((model) => model.id == healthPlanTemp.id);
      if (index >= 0) {
        List<HealthPlanModel> temp = [...state.healthPlansUpdated];
        temp.replaceRange(index, index + 1, [healthPlanTemp]);
        emit(state.copyWith(
          healthPlansUpdated: temp,
          status: PatientSaveStateStatus.updated,
        ));
      }
    } catch (_) {
      emit(state.copyWith(
          status: PatientSaveStateStatus.error,
          error: 'Erro ao atualizar plano de saude'));
    }
  }

  FutureOr<void> _onPatientSaveEventRemoveHealthPlan(
      PatientSaveEventRemoveHealthPlan event,
      Emitter<PatientSaveState> emit) async {
    emit(state.copyWith(status: PatientSaveStateStatus.loading));
    try {
      HealthPlanModel healthPlanTemp = event.model.copyWith();
      await _healthPlanRepository.delete(healthPlanTemp.id!);
      List<HealthPlanModel> temp = [...state.healthPlansUpdated];
      temp.removeWhere((element) => element == event.model);
      emit(state.copyWith(healthPlansUpdated: temp));
    } catch (_) {
      emit(state.copyWith(
          status: PatientSaveStateStatus.error,
          error: 'Erro ao atualizar plano de saude'));
    }
  }

  Future<List<HealthPlanModel>> updateRelationHealthPlan(String modelId) async {
    List<HealthPlanModel> listResult = [];
    List<HealthPlanModel> listFinal = [];
    listResult.addAll([...state.healthPlansUpdated]);
    listFinal.addAll([...state.healthPlansOriginal]);
    for (var original in state.healthPlansOriginal) {
      int index = state.healthPlansUpdated
          .indexWhere((model) => model.id == original.id);
      if (index < 0) {
        await _repository.updateRelationHealthPlans(
            modelId, [original.id!], false);
        listFinal.removeWhere((element) => element.id == original.id);
      } else {
        listResult.removeWhere((element) => element.id == original.id);
      }
    }
    for (var result in listResult) {
      await _repository.updateRelationHealthPlans(modelId, [result.id!], true);
      listFinal.add(result);
    }
    return listFinal;
  }
}
