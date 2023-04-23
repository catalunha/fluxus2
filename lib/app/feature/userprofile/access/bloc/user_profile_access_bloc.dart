import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/office_model.dart';
import '../../../../core/models/procedure_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/user_profile_repository.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import 'user_profile_access_event.dart';
import 'user_profile_access_state.dart';

class UserProfileAccessBloc
    extends Bloc<UserProfileAccessEvent, UserProfileAccessState> {
  final UserProfileRepository _repository;

  UserProfileAccessBloc(
      {required UserProfileModel model,
      required UserProfileRepository repository})
      : _repository = repository,
        super(UserProfileAccessState.initial(model)) {
    on<UserProfileAccessEventStart>(_onUserProfileAccessEventStart);

    on<UserProfileAccessEventFormSubmitted>(
        _onUserProfileAccessEventFormSubmitted);
    on<UserProfileAccessEventUpdateAccess>(
        _onUserProfileAccessEventUpdateAccess);
    on<UserProfileAccessEventAddOffice>(_onUserProfileAccessEventAddOffice);
    on<UserProfileAccessEventRemoveOffice>(
        _onUserProfileAccessEventRemoveOffice);
    on<UserProfileAccessEventAddExpertise>(
        _onUserProfileAccessEventAddExpertise);
    on<UserProfileAccessEventRemoveExpertise>(
        _onUserProfileAccessEventRemoveExpertise);
    on<UserProfileAccessEventAddProcedure>(
        _onUserProfileAccessEventAddProcedure);
    on<UserProfileAccessEventRemoveProcedure>(
        _onUserProfileAccessEventRemoveProcedure);
    add(UserProfileAccessEventStart());
  }
  FutureOr<void> _onUserProfileAccessEventStart(
      UserProfileAccessEventStart event,
      Emitter<UserProfileAccessState> emit) async {
    print('UserProfileAccessBloc Staaaaaaaarting....');
    emit(state.copyWith(status: UserProfileAccessStateStatus.loading));
    try {
      UserProfileModel? temp =
          await _repository.readById(state.model.id, UserProfileEntity.allCols);
      emit(state.copyWith(
        model: temp,
        status: UserProfileAccessStateStatus.updated,
        officesOriginal: temp!.offices ?? [],
        officesUpdated: temp.offices ?? [],
        expertisesOriginal: temp.expertises ?? [],
        expertisesUpdated: temp.expertises ?? [],
        proceduresOriginal: temp.procedures ?? [],
        proceduresUpdated: temp.procedures ?? [],
      ));
    } catch (e) {
      //print(e);
      emit(state.copyWith(
          status: UserProfileAccessStateStatus.error,
          error: 'Erro ao buscar dados do paciente'));
    }
  }

  FutureOr<void> _onUserProfileAccessEventFormSubmitted(
      UserProfileAccessEventFormSubmitted event,
      Emitter<UserProfileAccessState> emit) async {
    emit(state.copyWith(status: UserProfileAccessStateStatus.loading));
    try {
      UserProfileModel model = state.model.copyWith(
        isActive: event.isActive,
        access: state.access,
      );

      String userProfileId = await _repository.update(model);
      List<OfficeModel> officesResult =
          await updateRelationOffice(userProfileId);
      List<ExpertiseModel> expertisesResult =
          await updateRelationExpertise(userProfileId);
      List<ProcedureModel> proceduresResult =
          await updateRelationProcedure(userProfileId);

      model = model.copyWith(
        offices: officesResult,
        expertises: expertisesResult,
        procedures: proceduresResult,
      );
      emit(state.copyWith(
          model: model, status: UserProfileAccessStateStatus.success));
    } catch (_) {
      emit(state.copyWith(
          status: UserProfileAccessStateStatus.error,
          error: 'Erro ao salvar dados neste perfil'));
    }
  }

  FutureOr<void> _onUserProfileAccessEventUpdateAccess(
      UserProfileAccessEventUpdateAccess event,
      Emitter<UserProfileAccessState> emit) {
    List<String> access = [...state.access];
    if (access.contains(event.access)) {
      access.remove(event.access);
    } else {
      access.add(event.access);
    }
    emit(state.copyWith(access: access));
  }

  FutureOr<void> _onUserProfileAccessEventAddOffice(
      UserProfileAccessEventAddOffice event,
      Emitter<UserProfileAccessState> emit) {
    int index =
        state.officesUpdated.indexWhere((model) => model.id == event.model.id);
    if (index < 0) {
      List<OfficeModel> temp = [...state.officesUpdated];
      temp.add(event.model);
      emit(state.copyWith(officesUpdated: temp));
    }
  }

  FutureOr<void> _onUserProfileAccessEventRemoveOffice(
      UserProfileAccessEventRemoveOffice event,
      Emitter<UserProfileAccessState> emit) {
    List<OfficeModel> temp = [...state.officesUpdated];
    temp.removeWhere((element) => element.id == event.model.id);
    emit(state.copyWith(officesUpdated: temp));
  }

  Future<List<OfficeModel>> updateRelationOffice(String modelId) async {
    List<OfficeModel> listResult = [];
    List<OfficeModel> listFinal = [];
    listResult.addAll([...state.officesUpdated]);
    listFinal.addAll([...state.officesOriginal]);
    for (var original in state.officesOriginal) {
      int index =
          state.officesUpdated.indexWhere((model) => model.id == original.id);
      if (index < 0) {
        await _repository.updateRelationOffices(modelId, [original.id!], false);
        listFinal.removeWhere((element) => element.id == original.id);
      } else {
        listResult.removeWhere((element) => element.id == original.id);
      }
    }
    for (var result in listResult) {
      await _repository.updateRelationOffices(modelId, [result.id!], true);
      listFinal.add(result);
    }
    return listFinal;
  }

  FutureOr<void> _onUserProfileAccessEventAddExpertise(
      UserProfileAccessEventAddExpertise event,
      Emitter<UserProfileAccessState> emit) {
    int index = state.expertisesUpdated
        .indexWhere((model) => model.id == event.model.id);
    if (index < 0) {
      List<ExpertiseModel> temp = [...state.expertisesUpdated];
      temp.add(event.model);
      emit(state.copyWith(expertisesUpdated: temp));
    }
  }

  FutureOr<void> _onUserProfileAccessEventRemoveExpertise(
      UserProfileAccessEventRemoveExpertise event,
      Emitter<UserProfileAccessState> emit) {
    List<ExpertiseModel> temp = [...state.expertisesUpdated];
    temp.removeWhere((element) => element.id == event.model.id);
    emit(state.copyWith(expertisesUpdated: temp));
  }

  Future<List<ExpertiseModel>> updateRelationExpertise(String modelId) async {
    List<ExpertiseModel> listResult = [];
    List<ExpertiseModel> listFinal = [];
    listResult.addAll([...state.expertisesUpdated]);
    listFinal.addAll([...state.expertisesOriginal]);
    for (var original in state.expertisesOriginal) {
      int index = state.expertisesUpdated
          .indexWhere((model) => model.id == original.id);
      if (index < 0) {
        await _repository.updateRelationExpertises(
            modelId, [original.id!], false);
        listFinal.removeWhere((element) => element.id == original.id);
      } else {
        listResult.removeWhere((element) => element.id == original.id);
      }
    }
    for (var result in listResult) {
      await _repository.updateRelationExpertises(modelId, [result.id!], true);
      listFinal.add(result);
    }
    return listFinal;
  }

  FutureOr<void> _onUserProfileAccessEventAddProcedure(
      UserProfileAccessEventAddProcedure event,
      Emitter<UserProfileAccessState> emit) {
    int index = state.proceduresUpdated
        .indexWhere((model) => model.id == event.model.id);
    if (index < 0) {
      List<ProcedureModel> temp = [...state.proceduresUpdated];
      temp.add(event.model);
      emit(state.copyWith(proceduresUpdated: temp));
    }
  }

  FutureOr<void> _onUserProfileAccessEventRemoveProcedure(
      UserProfileAccessEventRemoveProcedure event,
      Emitter<UserProfileAccessState> emit) {
    List<ProcedureModel> temp = [...state.proceduresUpdated];
    temp.removeWhere((element) => element.id == event.model.id);
    emit(state.copyWith(proceduresUpdated: temp));
  }

  Future<List<ProcedureModel>> updateRelationProcedure(String modelId) async {
    List<ProcedureModel> listResult = [];
    List<ProcedureModel> listFinal = [];
    listResult.addAll([...state.proceduresUpdated]);
    listFinal.addAll([...state.proceduresOriginal]);
    for (var original in state.proceduresOriginal) {
      int index = state.proceduresUpdated
          .indexWhere((model) => model.id == original.id);
      if (index < 0) {
        await _repository.updateRelationProcedures(
            modelId, [original.id!], false);
        listFinal.removeWhere((element) => element.id == original.id);
      } else {
        listResult.removeWhere((element) => element.id == original.id);
      }
    }
    for (var result in listResult) {
      await _repository.updateRelationProcedures(modelId, [result.id!], true);
      listFinal.add(result);
    }
    return listFinal;
  }
}
