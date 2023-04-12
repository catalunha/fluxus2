import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/graduation_model.dart';
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
      List<GraduationModel> expertisesTemp = [...state.graduationsUpdated];
      expertisesTemp.add(event.model);
      emit(state.copyWith(graduationsUpdated: expertisesTemp));
    }
  }

  FutureOr<void> _onUserProfileSaveEventRemoveGraduation(
      UserProfileSaveEventRemoveGraduation event,
      Emitter<UserProfileSaveState> emit) {
    List<GraduationModel> expertisesTemp = [...state.graduationsUpdated];
    expertisesTemp.removeWhere((element) => element.id == event.model.id);
    emit(state.copyWith(graduationsUpdated: expertisesTemp));
  }

  Future<List<GraduationModel>> updateRelationGraduation(String modelId) async {
    List<GraduationModel> listResult = [];
    List<GraduationModel> listFinal = [];
    listResult.addAll([...state.graduationsUpdated]);
    listFinal.addAll([...state.graduationsOriginal]);
    for (var expertiseOriginal in state.graduationsOriginal) {
      int index = state.graduationsUpdated
          .indexWhere((model) => model.id == expertiseOriginal.id);
      if (index < 0) {
        await _repository.updateRelationGraduations(
            modelId, [expertiseOriginal.id!], false);
        listFinal.removeWhere((element) => element.id == expertiseOriginal.id);
      } else {
        listResult.removeWhere((element) => element.id == expertiseOriginal.id);
      }
    }
    for (var expertiseResult in listResult) {
      await _repository.updateRelationGraduations(
          modelId, [expertiseResult.id!], true);
      listFinal.add(expertiseResult);
    }
    return listFinal;
  }
}
