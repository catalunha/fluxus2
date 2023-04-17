import 'package:flutter/foundation.dart';

import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/office_model.dart';
import '../../../../core/models/procedure_model.dart';
import '../../../../core/models/user_profile_model.dart';

enum UserProfileAccessStateStatus { initial, loading, success, error }

class UserProfileAccessState {
  final UserProfileAccessStateStatus status;
  final String? error;
  final List<String> access;
  final UserProfileModel model;
  final List<OfficeModel> officesOriginal;
  final List<OfficeModel> officesUpdated;
  final List<ExpertiseModel> expertisesOriginal;
  final List<ExpertiseModel> expertisesUpdated;
  final List<ProcedureModel> proceduresOriginal;
  final List<ProcedureModel> proceduresUpdated;
  UserProfileAccessState({
    required this.status,
    this.error,
    required this.access,
    required this.model,
    this.officesOriginal = const [],
    this.officesUpdated = const [],
    this.expertisesOriginal = const [],
    this.expertisesUpdated = const [],
    this.proceduresOriginal = const [],
    this.proceduresUpdated = const [],
  });
  UserProfileAccessState.initial(this.model)
      : status = UserProfileAccessStateStatus.initial,
        error = '',
        access = model.access,
        officesOriginal = model.offices ?? [],
        officesUpdated = model.offices ?? [],
        expertisesOriginal = model.expertises ?? [],
        expertisesUpdated = model.expertises ?? [],
        proceduresOriginal = model.procedures ?? [],
        proceduresUpdated = model.procedures ?? [];

  UserProfileAccessState copyWith({
    UserProfileAccessStateStatus? status,
    String? error,
    List<String>? access,
    UserProfileModel? model,
    List<OfficeModel>? officesOriginal,
    List<OfficeModel>? officesUpdated,
    List<ExpertiseModel>? expertisesOriginal,
    List<ExpertiseModel>? expertisesUpdated,
    List<ProcedureModel>? proceduresOriginal,
    List<ProcedureModel>? proceduresUpdated,
  }) {
    return UserProfileAccessState(
      status: status ?? this.status,
      error: error ?? this.error,
      access: access ?? this.access,
      model: model ?? this.model,
      officesOriginal: officesOriginal ?? this.officesOriginal,
      officesUpdated: officesUpdated ?? this.officesUpdated,
      expertisesOriginal: expertisesOriginal ?? this.expertisesOriginal,
      expertisesUpdated: expertisesUpdated ?? this.expertisesUpdated,
      proceduresOriginal: proceduresOriginal ?? this.proceduresOriginal,
      proceduresUpdated: proceduresUpdated ?? this.proceduresUpdated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileAccessState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.access, access) &&
        other.model == model &&
        listEquals(other.officesOriginal, officesOriginal) &&
        listEquals(other.officesUpdated, officesUpdated) &&
        listEquals(other.expertisesOriginal, expertisesOriginal) &&
        listEquals(other.expertisesUpdated, expertisesUpdated) &&
        listEquals(other.proceduresOriginal, proceduresOriginal) &&
        listEquals(other.proceduresUpdated, proceduresUpdated);
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        access.hashCode ^
        model.hashCode ^
        officesOriginal.hashCode ^
        officesUpdated.hashCode ^
        expertisesOriginal.hashCode ^
        expertisesUpdated.hashCode ^
        proceduresOriginal.hashCode ^
        proceduresUpdated.hashCode;
  }

  @override
  String toString() {
    return 'UserProfileAccessState(status: $status, error: $error, access: $access, model: $model, officesOriginal: $officesOriginal, officesUpdated: $officesUpdated, expertisesOriginal: $expertisesOriginal, expertisesUpdated: $expertisesUpdated, proceduresOriginal: $proceduresOriginal, proceduresUpdated: $proceduresUpdated)';
  }
}
