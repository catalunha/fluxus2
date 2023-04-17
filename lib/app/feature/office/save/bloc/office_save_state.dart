import '../../../../core/models/office_model.dart';

enum OfficeSaveStateStatus { initial, loading, success, error }

class OfficeSaveState {
  final OfficeSaveStateStatus status;
  final String? error;
  final OfficeModel? model;
  OfficeSaveState({
    required this.status,
    this.error,
    this.model,
  });
  OfficeSaveState.initial(this.model)
      : status = OfficeSaveStateStatus.initial,
        error = '';
  OfficeSaveState copyWith({
    OfficeSaveStateStatus? status,
    String? error,
    OfficeModel? model,
  }) {
    return OfficeSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OfficeSaveState &&
        other.status == status &&
        other.error == error &&
        other.model == model;
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ model.hashCode;
  }
}
