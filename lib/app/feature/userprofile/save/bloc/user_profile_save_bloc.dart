import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/graduation_model.dart';
import '../../../../core/models/procedure_model.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/user_profile_repository.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/b4a/utils/xfile_to_parsefile.dart';
import 'user_profile_save_event.dart';
import 'user_profile_save_state.dart';

class UserProfileSaveBloc
    extends Bloc<UserProfileSaveEvent, UserProfileSaveState> {
  final UserProfileRepository _repository;
  UserProfileSaveBloc(
      {required UserModel model, required UserProfileRepository repository})
      : _repository = repository,
        super(UserProfileSaveState.initial(model)) {
    on<UserProfileSaveEventFormSubmitted>(_onUserProfileSaveEventFormSubmitted);
    on<UserProfileSaveEventSendXFile>(_onUserProfileSaveEventSendXFile);
    on<UserProfileSaveEventAddGraduation>(_onUserProfileSaveEventAddGraduation);
    on<UserProfileSaveEventRemoveGraduation>(
        _onUserProfileSaveEventRemoveGraduation);
    on<UserProfileSaveEventAddExpertise>(_onUserProfileSaveEventAddExpertise);
    on<UserProfileSaveEventRemoveExpertise>(
        _onUserProfileSaveEventRemoveExpertise);
    on<UserProfileSaveEventAddProcedure>(_onUserProfileSaveEventAddProcedure);
    on<UserProfileSaveEventRemoveProcedure>(
        _onUserProfileSaveEventRemoveProcedure);
  }

  FutureOr<void> _onUserProfileSaveEventFormSubmitted(
      UserProfileSaveEventFormSubmitted event,
      Emitter<UserProfileSaveState> emit) async {
    emit(state.copyWith(status: UserProfileSaveStateStatus.loading));
    try {
      UserProfileModel userProfileModel = state.user.userProfile!.copyWith(
        nickname: event.nickname,
        name: event.name,
        cpf: event.cpf,
        phone: event.phone,
        address: event.address,
        register: event.register,
        isFemale: event.isFemale,
        birthday: event.birthday,
      );

      String userProfileId = await _repository.update(userProfileModel);
      if (state.xfile != null) {
        String? photoUrl = await XFileToParseFile.xFileToParseFile(
          xfile: state.xfile!,
          className: UserProfileEntity.className,
          objectId: userProfileId,
          objectAttribute: 'photo',
        );
        userProfileModel = userProfileModel.copyWith(photo: photoUrl);
      }
      List<GraduationModel> graduationsResult =
          await updateRelationGraduation(userProfileId);
      List<ExpertiseModel> expertisesResult =
          await updateRelationExpertise(userProfileId);
      List<ProcedureModel> proceduresResult =
          await updateRelationProcedure(userProfileId);
      userProfileModel = userProfileModel.copyWith(
        id: userProfileId,
        graduations: graduationsResult,
        expertises: expertisesResult,
        procedures: proceduresResult,
      );

      UserModel user = state.user.copyWith(userProfile: userProfileModel);

      emit(state.copyWith(
          user: user, status: UserProfileSaveStateStatus.success));
    } catch (_) {
      emit(state.copyWith(
          status: UserProfileSaveStateStatus.error,
          error: 'Erro ao salvar dados no seu perfil'));
    }
  }

  FutureOr<void> _onUserProfileSaveEventSendXFile(
      UserProfileSaveEventSendXFile event, Emitter<UserProfileSaveState> emit) {
    emit(state.copyWith(xfile: event.xfile));
  }

  FutureOr<void> _onUserProfileSaveEventAddGraduation(
      UserProfileSaveEventAddGraduation event,
      Emitter<UserProfileSaveState> emit) {
    int index = state.graduationsUpdated
        .indexWhere((model) => model.id == event.model.id);
    if (index < 0) {
      List<GraduationModel> temp = [...state.graduationsUpdated];
      temp.add(event.model);
      emit(state.copyWith(graduationsUpdated: temp));
    }
  }

  FutureOr<void> _onUserProfileSaveEventRemoveGraduation(
      UserProfileSaveEventRemoveGraduation event,
      Emitter<UserProfileSaveState> emit) {
    List<GraduationModel> temp = [...state.graduationsUpdated];
    temp.removeWhere((element) => element.id == event.model.id);
    emit(state.copyWith(graduationsUpdated: temp));
  }

  Future<List<GraduationModel>> updateRelationGraduation(String modelId) async {
    List<GraduationModel> listResult = [];
    List<GraduationModel> listFinal = [];
    listResult.addAll([...state.graduationsUpdated]);
    listFinal.addAll([...state.graduationsOriginal]);
    for (var original in state.graduationsOriginal) {
      int index = state.graduationsUpdated
          .indexWhere((model) => model.id == original.id);
      if (index < 0) {
        await _repository.updateRelationGraduations(
            modelId, [original.id!], false);
        listFinal.removeWhere((element) => element.id == original.id);
      } else {
        listResult.removeWhere((element) => element.id == original.id);
      }
    }
    for (var result in listResult) {
      await _repository.updateRelationGraduations(modelId, [result.id!], true);
      listFinal.add(result);
    }
    return listFinal;
  }

  FutureOr<void> _onUserProfileSaveEventAddExpertise(
      UserProfileSaveEventAddExpertise event,
      Emitter<UserProfileSaveState> emit) {
    int index = state.expertisesUpdated
        .indexWhere((model) => model.id == event.model.id);
    if (index < 0) {
      List<ExpertiseModel> temp = [...state.expertisesUpdated];
      temp.add(event.model);
      emit(state.copyWith(expertisesUpdated: temp));
    }
  }

  FutureOr<void> _onUserProfileSaveEventRemoveExpertise(
      UserProfileSaveEventRemoveExpertise event,
      Emitter<UserProfileSaveState> emit) {
    List<ExpertiseModel> temp = [...state.expertisesUpdated];
    temp.removeWhere((element) => element.id == event.model.id);
    emit(state.copyWith(expertisesUpdated: temp));
  }

  Future<List<ExpertiseModel>> updateRelationExpertise(String modelId) async {
    List<ExpertiseModel> listResult = [];
    List<ExpertiseModel> listFinal = [];
    listResult.addAll([...state.expertisesUpdated]);
    listFinal.addAll([...state.expertisesOriginal]);
    for (var original in state.graduationsOriginal) {
      int index = state.graduationsUpdated
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

  FutureOr<void> _onUserProfileSaveEventAddProcedure(
      UserProfileSaveEventAddProcedure event,
      Emitter<UserProfileSaveState> emit) {
    int index = state.proceduresUpdated
        .indexWhere((model) => model.id == event.model.id);
    if (index < 0) {
      List<ProcedureModel> temp = [...state.proceduresUpdated];
      temp.add(event.model);
      emit(state.copyWith(proceduresUpdated: temp));
    }
  }

  FutureOr<void> _onUserProfileSaveEventRemoveProcedure(
      UserProfileSaveEventRemoveProcedure event,
      Emitter<UserProfileSaveState> emit) {
    List<ProcedureModel> temp = [...state.proceduresUpdated];
    temp.removeWhere((element) => element.id == event.model.id);
    emit(state.copyWith(proceduresUpdated: temp));
  }

  Future<List<ProcedureModel>> updateRelationProcedure(String modelId) async {
    List<ProcedureModel> listResult = [];
    List<ProcedureModel> listFinal = [];
    listResult.addAll([...state.proceduresUpdated]);
    listFinal.addAll([...state.proceduresOriginal]);
    for (var original in state.graduationsOriginal) {
      int index = state.graduationsUpdated
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
