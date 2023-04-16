import '../../../../core/models/room_model.dart';

enum RoomSaveStateStatus { initial, loading, success, error }

class RoomSaveState {
  final RoomSaveStateStatus status;
  final String? error;
  final RoomModel? model;
  RoomSaveState({
    required this.status,
    this.error,
    this.model,
  });
  RoomSaveState.initial(this.model)
      : status = RoomSaveStateStatus.initial,
        error = '';
  RoomSaveState copyWith({
    RoomSaveStateStatus? status,
    String? error,
    RoomModel? model,
  }) {
    return RoomSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoomSaveState &&
        other.status == status &&
        other.error == error &&
        other.model == model;
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ model.hashCode;
  }
}
