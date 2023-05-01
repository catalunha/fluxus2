import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/models/attendance_model.dart';
import '../../../../../../core/models/event_model.dart';
import '../../../../../../core/repositories/event_repository.dart';
import '../../../../../../data/b4a/entity/attendance_entity.dart';
import '../../../../../../data/b4a/entity/event_entity.dart';
import 'event_add_event.dart';
import 'event_add_state.dart';

class EventAddBloc extends Bloc<EventAddEvent, EventAddState> {
  final EventRepository _repository;
  EventAddBloc({
    required EventModel? model,
    required EventRepository repository,
  })  : _repository = repository,
        super(EventAddState.initial(model)) {
    on<EventAddEventStart>(_onEventAddEventStart);

    on<EventAddEventFormSubmitted>(_onEventAddEventFormSubmitted);
    on<EventAddEventAddRoom>(_onEventAddEventAddRoom);
    on<EventAddEventAddStatus>(_onEventAddEventAddStatus);
    on<EventAddEventAddAttendance>(_onEventAddEventAddAttendance);
    on<EventAddEventRemoveAttendance>(_onEventAddEventRemoveAttendance);
    if (model == null) {
    } else {
      add(EventAddEventStart());
    }
  }

  final List<String> cols = [
    ...EventEntity.singleCols,
    ...AttendanceEntity.selectedCols([
      AttendanceEntity.professional,
      AttendanceEntity.procedure,
      AttendanceEntity.patient,
      AttendanceEntity.healthPlan,
      'healthPlan.healthPlanType',
    ]),
  ];

  FutureOr<void> _onEventAddEventStart(
      EventAddEventStart event, Emitter<EventAddState> emit) async {
    print('Staaaaaaaarting....');
    emit(state.copyWith(status: EventAddStateStatus.loading));
    try {
      EventModel? temp = await _repository.readById(state.model!.id!, cols);
      emit(state.copyWith(
        model: temp,
        attendancesOriginal: temp?.attendances ?? [],
        attendancesUpdated: temp?.attendances ?? [],
        room: temp?.room,
        statusEvent: temp?.status,
        status: EventAddStateStatus.updated,
      ));
    } catch (e) {
      //print(e);
      emit(state.copyWith(
          status: EventAddStateStatus.error,
          error: 'Erro ao buscar dados do paciente'));
    }
  }

  FutureOr<void> _onEventAddEventFormSubmitted(
      EventAddEventFormSubmitted event, Emitter<EventAddState> emit) async {
    emit(state.copyWith(status: EventAddStateStatus.loading));
    try {
      EventModel model;
      String? history = event.history;
      final dateFormat = DateFormat('dd/MM/y HH:mm');

      if (history != null && history.isNotEmpty) {
        history =
            '* ${dateFormat.format(DateTime.now())}\n$history\n${state.model?.history}';
      }

      if (state.model == null) {
        model = EventModel(
          status: state.statusEvent,
          room: state.room,
          start: event.start,
          end: event.end,
          history: history,
        );
      } else {
        model = state.model!.copyWith(
          status: state.statusEvent,
          room: state.room,
          start: event.start,
          end: event.end,
          history: history,
        );
      }
      String patientId = await _repository.update(model);
      List<AttendanceModel> attendancesResults =
          await updateRelationAttendance(patientId);
      model = model.copyWith(
        id: patientId,
        attendances: attendancesResults,
      );

      emit(state.copyWith(model: model, status: EventAddStateStatus.success));
    } catch (e) {
      //print(e);
      emit(state.copyWith(
          status: EventAddStateStatus.error,
          error: 'Erro ao salvar dados do paciente'));
    }
  }

  FutureOr<void> _onEventAddEventAddRoom(
      EventAddEventAddRoom event, Emitter<EventAddState> emit) {
    emit(state.copyWith(room: event.model));
  }

  FutureOr<void> _onEventAddEventAddStatus(
      EventAddEventAddStatus event, Emitter<EventAddState> emit) {
    emit(state.copyWith(statusEvent: event.model));
  }

  FutureOr<void> _onEventAddEventAddAttendance(
      EventAddEventAddAttendance event, Emitter<EventAddState> emit) {
    List<AttendanceModel> temp = [...state.attendancesUpdated];
    temp.add(event.model);
    emit(state.copyWith(attendancesUpdated: temp));
  }

  FutureOr<void> _onEventAddEventRemoveAttendance(
      EventAddEventRemoveAttendance event, Emitter<EventAddState> emit) {
    List<AttendanceModel> temp = [...state.attendancesUpdated];
    temp.remove(event.model);
    emit(state.copyWith(attendancesUpdated: temp));
  }

  Future<List<AttendanceModel>> updateRelationAttendance(String modelId) async {
    List<AttendanceModel> listResult = [];
    List<AttendanceModel> listFinal = [];
    listResult.addAll([...state.attendancesUpdated]);
    listFinal.addAll([...state.attendancesOriginal]);
    for (var original in state.attendancesOriginal) {
      int index = state.attendancesUpdated
          .indexWhere((model) => model.id == original.id);
      if (index < 0) {
        await _repository.updateRelationAttendances(
            modelId, [original.id!], false);
        listFinal.removeWhere((element) => element.id == original.id);
      } else {
        listResult.removeWhere((element) => element.id == original.id);
      }
    }
    for (var result in listResult) {
      await _repository.updateRelationAttendances(modelId, [result.id!], true);
      listFinal.add(result);
    }
    return listFinal;
  }
}
