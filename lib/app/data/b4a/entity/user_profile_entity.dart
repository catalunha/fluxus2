import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/user_profile_model.dart';
import 'graduation_entity.dart';

class UserProfileEntity {
  static const String className = 'UserProfile';
  // Nome do campo local =  no Database
  static const String id = 'objectId';
  static const String email = 'email';
  static const String nickname = 'nickname';
  static const String name = 'name';
  static const String cpf = 'cpf';
  static const String register = 'register';
  static const String phone = 'phone';
  static const String address = 'address';
  static const String photo = 'photo';
  static const String isFemale = 'isFemale';
  static const String isActive = 'isActive';
  static const String birthday = 'birthday';
  static const String access = 'access';
  static const String graduations = 'graduations';

  UserProfileModel fromParse(ParseObject parseObject) {
    UserProfileModel model = UserProfileModel(
      id: parseObject.objectId!,
      email: parseObject.get(UserProfileEntity.email),
      nickname: parseObject.get(UserProfileEntity.nickname),
      name: parseObject.get(UserProfileEntity.name),
      cpf: parseObject.get(UserProfileEntity.cpf),
      register: parseObject.get(UserProfileEntity.register),
      phone: parseObject.get(UserProfileEntity.phone),
      address: parseObject.get(UserProfileEntity.address),
      photo: parseObject.get(UserProfileEntity.photo)?.get('url'),
      isFemale: parseObject.get(UserProfileEntity.isFemale),
      isActive: parseObject.get(UserProfileEntity.isActive),
      birthday:
          parseObject.get<DateTime>(UserProfileEntity.birthday)?.toLocal(),
      access: parseObject.get<List<dynamic>>(UserProfileEntity.access) != null
          ? parseObject
              .get<List<dynamic>>(UserProfileEntity.access)!
              .map((e) => e.toString())
              .toList()
          : [],
    );
    return model;
  }

  Future<ParseObject> toParse(UserProfileModel model) async {
    final parseObject = ParseObject(UserProfileEntity.className);
    parseObject.objectId = model.id;

    if (model.nickname != null) {
      parseObject.set(UserProfileEntity.nickname, model.nickname);
    }
    if (model.name != null) {
      parseObject.set(UserProfileEntity.name, model.name);
    }
    if (model.cpf != null) {
      parseObject.set(UserProfileEntity.cpf, model.cpf);
    }
    if (model.register != null) {
      parseObject.set(UserProfileEntity.register, model.register);
    }

    if (model.phone != null) {
      parseObject.set(UserProfileEntity.phone, model.phone);
    }
    if (model.address != null) {
      parseObject.set(UserProfileEntity.address, model.address);
    }

    if (model.isFemale != null) {
      parseObject.set(UserProfileEntity.isFemale, model.isFemale);
    }

    if (model.birthday != null) {
      parseObject.set<DateTime?>(
          UserProfileEntity.birthday,
          DateTime(model.birthday!.year, model.birthday!.month,
              model.birthday!.day));
    }
    parseObject.set(UserProfileEntity.access, model.access);

    parseObject.set(UserProfileEntity.isActive, model.isActive);
    return parseObject;
  }

  ParseObject? toParseRelationGraduations({
    required String objectId,
    required List<String> ids,
    required bool add,
  }) {
    final parseObject = ParseObject(UserProfileEntity.className);
    parseObject.objectId = objectId;
    if (ids.isEmpty) {
      parseObject.unset(UserProfileEntity.graduations);
      return parseObject;
    }
    if (add) {
      parseObject.addRelation(
        UserProfileEntity.graduations,
        ids
            .map(
              (element) =>
                  ParseObject(GraduationEntity.className)..objectId = element,
            )
            .toList(),
      );
    } else {
      parseObject.removeRelation(
          UserProfileEntity.graduations,
          ids
              .map((element) =>
                  ParseObject(GraduationEntity.className)..objectId = element)
              .toList());
    }
    return parseObject;
  }
}
