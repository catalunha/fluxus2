import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/user_profile_model.dart';

class UserProfileEntity {
  static const String className = 'UserProfile';
  // Nome do campo local =  no Database
  static const String id = 'objectId';
  static const String email = 'email';
  static const String name = 'name';
  static const String cpf = 'cpf';
  static const String phone = 'phone';
  static const String photo = 'photo';
  static const String access = 'access';
  static const String isActive = 'isActive';

  UserProfileModel fromParse(ParseObject parseObject) {
    UserProfileModel profileModel = UserProfileModel(
      id: parseObject.objectId!,
      email: parseObject.get(UserProfileEntity.email),
      name: parseObject.get(UserProfileEntity.name),
      cpf: parseObject.get(UserProfileEntity.cpf),
      phone: parseObject.get(UserProfileEntity.phone),
      photo: parseObject.get(UserProfileEntity.photo)?.get('url'),
      access: parseObject.get<List<dynamic>>(UserProfileEntity.access) != null
          ? parseObject
              .get<List<dynamic>>(UserProfileEntity.access)!
              .map((e) => e.toString())
              .toList()
          : [],
      isActive: parseObject.get(UserProfileEntity.isActive),
    );
    return profileModel;
  }

  Future<ParseObject> toParse(UserProfileModel profileModel) async {
    final profileParseObject = ParseObject(UserProfileEntity.className);
    profileParseObject.objectId = profileModel.id;
    if (profileModel.name != null) {
      profileParseObject.set(UserProfileEntity.name, profileModel.name);
    }

    if (profileModel.phone != null) {
      profileParseObject.set(UserProfileEntity.phone, profileModel.phone);
    }
    if (profileModel.cpf != null) {
      profileParseObject.set(UserProfileEntity.cpf, profileModel.cpf);
    }

    if (profileModel.phone != null) {
      profileParseObject.set(UserProfileEntity.phone, profileModel.phone);
    }
    if (profileModel.access != null) {
      profileParseObject.set(UserProfileEntity.access, profileModel.access);
    }

    profileParseObject.set(UserProfileEntity.isActive, profileModel.isActive);
    return profileParseObject;
  }
}
