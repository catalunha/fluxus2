part of 'user_profile_edit_bloc.dart';

abstract class UserProfileEditEvent {}

class UserProfileEditEventSendXFile extends UserProfileEditEvent {
  final XFile? xfile;
  UserProfileEditEventSendXFile({
    required this.xfile,
  });
}

class UserProfileEditEventFormSubmitted extends UserProfileEditEvent {
  final String? name;
  final String? nickname;
  final String? cpf;
  final String? phone;
  final String? address;
  final String? register;
  final bool? isFemale;
  final DateTime? birthday;
  UserProfileEditEventFormSubmitted({
    this.name,
    this.nickname,
    this.cpf,
    this.phone,
    this.address,
    this.register,
    this.isFemale,
    this.birthday,
  });
}
