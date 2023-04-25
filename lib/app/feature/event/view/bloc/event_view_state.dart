import '../../../../core/models/event_model.dart';

enum EventViewStateStatus { initial, updated, loading, success, error }

class EventViewState {
  final EventViewStateStatus status;
  final String? error;
  final EventModel model;
  EventViewState({
    required this.status,
    this.error,
    required this.model,
  });
  EventViewState.initial(this.model)
      : status = EventViewStateStatus.initial,
        error = '';

  EventViewState copyWith({
    EventViewStateStatus? status,
    String? error,
    EventModel? model,
  }) {
    return EventViewState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }

  @override
  String toString() =>
      'EventViewState(status: $status, error: $error, model: $model)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventViewState &&
        other.status == status &&
        other.error == error &&
        other.model == model;
  }

  @override
  int get hashCode => status.hashCode ^ error.hashCode ^ model.hashCode;
}
