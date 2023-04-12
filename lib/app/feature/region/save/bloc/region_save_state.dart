import '../../../../core/models/region_model.dart';

enum RegionSaveStateStatus { initial, loading, success, error }

class RegionSaveState {
  final RegionSaveStateStatus status;
  final String? error;
  final RegionModel? model;
  RegionSaveState({
    required this.status,
    this.error,
    this.model,
  });
  RegionSaveState.initial(this.model)
      : status = RegionSaveStateStatus.initial,
        error = '';
  RegionSaveState copyWith({
    RegionSaveStateStatus? status,
    String? error,
    RegionModel? model,
  }) {
    return RegionSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegionSaveState &&
        other.status == status &&
        other.error == error &&
        other.model == model;
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ model.hashCode;
  }
}
