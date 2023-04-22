import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../../../core/models/attendance_model.dart';
import '../../../../../../core/models/event_model.dart';
import '../../../../../../core/repositories/attendance_repository.dart';
import 'schedule_confirm_presence_event.dart';
import 'schedule_confirm_presence_state.dart';

class ScheduleConfirmPresenceBloc
    extends Bloc<ScheduleConfirmPresenceEvent, ScheduleConfirmPresenceState> {
  final AttendanceRepository _repository;
  ScheduleConfirmPresenceBloc({
    required EventModel event,
    required AttendanceRepository repository,
  })  : _repository = repository,
        super(ScheduleConfirmPresenceState.initial(event)) {
    on<ScheduleConfirmPresenceEventOnInit>(
        _onScheduleConfirmPresenceEventOnInit);
    on<ScheduleConfirmPresenceEventAddConfirm>(
        _onScheduleConfirmPresenceEventAddConfirm);
    on<ScheduleConfirmPresenceEventRemoveConfirm>(
        _onScheduleConfirmPresenceEventRemoveConfirm);
    on<ScheduleConfirmPresenceEventUpdate>(
        _onScheduleConfirmPresenceEventUpdate);
    add(ScheduleConfirmPresenceEventOnInit());
  }
  FutureOr<void> _onScheduleConfirmPresenceEventOnInit(
      ScheduleConfirmPresenceEventOnInit event,
      Emitter<ScheduleConfirmPresenceState> emit) {
    final List<AttendanceModel> modelsUnconfirmedTemp = [];
    final List<AttendanceModel> modelsAlreadyConfirmedTemp = [];
    for (var model in state.event.attendances!) {
      if (model.confirmedPresence == null) {
        modelsUnconfirmedTemp.add(model);
      } else {
        modelsAlreadyConfirmedTemp.add(model);
      }
    }
    emit(state.copyWith(
        modelsUnconfirmed: modelsUnconfirmedTemp,
        modelsAlreadyConfirmed: modelsAlreadyConfirmedTemp));
  }

  FutureOr<void> _onScheduleConfirmPresenceEventAddConfirm(
      ScheduleConfirmPresenceEventAddConfirm event,
      Emitter<ScheduleConfirmPresenceState> emit) {
    final List<AttendanceModel> temp = [...state.modelsConfirmThese];
    temp.add(event.model);
    emit(state.copyWith(modelsConfirmThese: temp));
  }

  FutureOr<void> _onScheduleConfirmPresenceEventRemoveConfirm(
      ScheduleConfirmPresenceEventRemoveConfirm event,
      Emitter<ScheduleConfirmPresenceState> emit) {
    final List<AttendanceModel> temp = [...state.modelsConfirmThese];
    temp.remove(event.model);
    emit(state.copyWith(modelsConfirmThese: temp));
  }

  FutureOr<void> _onScheduleConfirmPresenceEventUpdate(
      ScheduleConfirmPresenceEventUpdate event,
      Emitter<ScheduleConfirmPresenceState> emit) async {
    emit(state.copyWith(status: ScheduleConfirmPresenceStateStatus.loading));
    try {
      List<AttendanceModel> tempList = [...state.modelsConfirmThese];
      for (var model in state.modelsConfirmThese) {
        AttendanceModel temp =
            model.copyWith(confirmedPresence: DateTime.now());
        await _repository.update(temp);

        int index = tempList.indexWhere((model) => model.id == temp.id);
        if (index >= 0) {
          tempList.replaceRange(index, index + 1, [temp]);
        }
      }
      emit(state.copyWith(
          modelsConfirmThese: tempList,
          status: ScheduleConfirmPresenceStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: ScheduleConfirmPresenceStateStatus.error,
          error: 'Erro ao salvar confirmPresence'));
    }
  }
}
