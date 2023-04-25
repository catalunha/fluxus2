import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/event_model.dart';
import '../../../../core/repositories/event_repository.dart';
import '../../../../data/b4a/entity/attendance_entity.dart';
import '../../../../data/b4a/entity/event_entity.dart';
import 'event_view_event.dart';
import 'event_view_state.dart';

class EventViewBloc extends Bloc<EventViewEvent, EventViewState> {
  final EventRepository _repository;
  EventViewBloc({
    required EventModel model,
    required EventRepository repository,
  })  : _repository = repository,
        super(EventViewState.initial(model)) {
    on<EventViewEventStart>(_onEventViewEventStart);
    add(EventViewEventStart());
  }
  List<String> cols = [
    ...EventEntity.singleCols,
    ...AttendanceEntity.selectedCols([
      AttendanceEntity.professional,
      AttendanceEntity.procedure,
      AttendanceEntity.patient,
      AttendanceEntity.healthPlan,
      'healthPlan.healthPlanType',
    ]),
  ];
  FutureOr<void> _onEventViewEventStart(
      EventViewEventStart event, Emitter<EventViewState> emit) async {
    emit(state.copyWith(status: EventViewStateStatus.loading));
    try {
      EventModel? temp = await _repository.readById(state.model.id!, cols);
      emit(state.copyWith(model: temp, status: EventViewStateStatus.updated));
    } catch (e) {
      //print(e);
      emit(state.copyWith(
          status: EventViewStateStatus.error,
          error: 'Erro ao buscar dados do paciente'));
    }
  }
}
