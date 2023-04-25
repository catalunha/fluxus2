import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/attendance_model.dart';
import '../../../../core/models/event_model.dart';
import '../../../../core/repositories/event_repository.dart';
import '../../../../data/b4a/entity/attendance_entity.dart';
import '../../../../data/b4a/entity/event_entity.dart';
import 'event_save_event.dart';
import 'event_save_state.dart';

class EventSaveBloc extends Bloc<EventSaveEvent, EventSaveState> {
  final EventRepository _repository;
  EventSaveBloc({
    required EventModel? model,
    required EventRepository repository,
  })  : _repository = repository,
        super(EventSaveState.initial(model)) {
    on<EventSaveEventStart>(_onEventSaveEventStart);

    on<EventSaveEventFormSubmitted>(_onEventSaveEventFormSubmitted);
    on<EventSaveEventAddRoom>(_onEventSaveEventAddRoom);
    on<EventSaveEventAddStatus>(_onEventSaveEventAddStatus);
    on<EventSaveEventAddAttendance>(_onEventSaveEventAddAttendance);
    on<EventSaveEventRemoveAttendance>(_onEventSaveEventRemoveAttendance);
    if (model == null) {
    } else {
      add(EventSaveEventStart());
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

  FutureOr<void> _onEventSaveEventStart(
      EventSaveEventStart event, Emitter<EventSaveState> emit) async {
    print('Staaaaaaaarting....');
    emit(state.copyWith(status: EventSaveStateStatus.loading));
    try {
      EventModel? temp = await _repository.readById(state.model!.id!, cols);
      emit(state.copyWith(
        model: temp,
        attendancesOriginal: temp?.attendances ?? [],
        attendancesUpdated: temp?.attendances ?? [],
        room: temp?.room,
        statusEvent: temp?.status,
        status: EventSaveStateStatus.updated,
      ));
    } catch (e) {
      //print(e);
      emit(state.copyWith(
          status: EventSaveStateStatus.error,
          error: 'Erro ao buscar dados do paciente'));
    }
  }

  FutureOr<void> _onEventSaveEventFormSubmitted(
      EventSaveEventFormSubmitted event, Emitter<EventSaveState> emit) async {
    emit(state.copyWith(status: EventSaveStateStatus.loading));
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

      emit(state.copyWith(model: model, status: EventSaveStateStatus.success));
    } catch (e) {
      //print(e);
      emit(state.copyWith(
          status: EventSaveStateStatus.error,
          error: 'Erro ao salvar dados do paciente'));
    }
  }

  FutureOr<void> _onEventSaveEventAddRoom(
      EventSaveEventAddRoom event, Emitter<EventSaveState> emit) {
    emit(state.copyWith(room: event.model));
  }

  FutureOr<void> _onEventSaveEventAddStatus(
      EventSaveEventAddStatus event, Emitter<EventSaveState> emit) {
    emit(state.copyWith(statusEvent: event.model));
  }

  FutureOr<void> _onEventSaveEventAddAttendance(
      EventSaveEventAddAttendance event, Emitter<EventSaveState> emit) {
    List<AttendanceModel> temp = [...state.attendancesUpdated];
    temp.add(event.model);
    emit(state.copyWith(attendancesUpdated: temp));
  }

  FutureOr<void> _onEventSaveEventRemoveAttendance(
      EventSaveEventRemoveAttendance event, Emitter<EventSaveState> emit) {
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
