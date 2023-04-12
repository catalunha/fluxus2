import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/user_profile_repository.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/b4a/utils/xfile_to_parsefile.dart';

part 'user_profile_edit_event.dart';
part 'user_profile_edit_state.dart';

class UserProfileEditBloc
    extends Bloc<UserProfileEditEvent, UserProfileEditState> {
  final UserProfileRepository _userProfileRepository;
  UserProfileEditBloc(
      {required UserModel userModel,
      required UserProfileRepository userProfileRepository})
      : _userProfileRepository = userProfileRepository,
        super(UserProfileEditState.initial(userModel)) {
    on<UserProfileEditEventFormSubmitted>(_onUserProfileEditEventFormSubmitted);
    on<UserProfileEditEventSendXFile>(_onUserProfileEditEventSendXFile);
  }

  FutureOr<void> _onUserProfileEditEventFormSubmitted(
      UserProfileEditEventFormSubmitted event,
      Emitter<UserProfileEditState> emit) async {
    emit(state.copyWith(status: UserProfileEditStateStatus.loading));
    try {
      UserProfileModel userProfileModel = state.user.userProfile!.copyWith(
        name: event.name,
        cpf: event.cpf,
        phone: event.phone,
      );

      String userProfileId =
          await _userProfileRepository.update(userProfileModel);
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
          user: user, status: UserProfileEditStateStatus.success));
    } catch (_) {
      emit(state.copyWith(
          status: UserProfileEditStateStatus.error,
          error: 'Erro ao salvar dados no seu perfil'));
    }
  }

  FutureOr<void> _onUserProfileEditEventSendXFile(
      UserProfileEditEventSendXFile event, Emitter<UserProfileEditState> emit) {
    emit(state.copyWith(xfile: event.xfile));
  }
}
