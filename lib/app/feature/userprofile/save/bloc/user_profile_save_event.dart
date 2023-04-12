import 'package:image_picker/image_picker.dart';

import '../../../../core/models/graduation_model.dart';

abstract class UserProfileSaveEvent {}

class UserProfileSaveEventSendXFile extends UserProfileSaveEvent {
  final XFile? xfile;
  UserProfileSaveEventSendXFile({
    required this.xfile,
  });
}

class UserProfileSaveEventFormSubmitted extends UserProfileSaveEvent {
  final String? name;
  final String? nickname;
  final String? cpf;
  final String? phone;
  final String? address;
  final String? register;
  final bool? isFemale;
  final DateTime? birthday;
  UserProfileSaveEventFormSubmitted({
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

class UserProfileSaveEventAddGraduation extends UserProfileSaveEvent {
  final GraduationModel model;
  UserProfileSaveEventAddGraduation(
    this.model,
  );
}

class UserProfileSaveEventRemoveGraduation extends UserProfileSaveEvent {
  final GraduationModel model;
  UserProfileSaveEventRemoveGraduation(
    this.model,
  );
}
