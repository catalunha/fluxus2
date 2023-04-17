import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/Attendance_model.dart';
import '../../../../core/repositories/Attendance_repository.dart';
import 'Attendance_save_event.dart';
import 'Attendance_save_state.dart';

class AttendanceSaveBloc
    extends Bloc<AttendanceSaveEvent, AttendanceSaveState> {
  final AttendanceRepository _AttendanceRepository;
  AttendanceSaveBloc({
    required AttendanceModel? AttendanceModel,
    required AttendanceRepository AttendanceRepository,
  })  : _AttendanceRepository = AttendanceRepository,
        super(AttendanceSaveState.initial(AttendanceModel)) {
    on<AttendanceSaveEventFormSubmitted>(_onAttendanceSaveEventFormSubmitted);
    on<AttendanceSaveEventDelete>(_onAttendanceSaveEventDelete);
  }

  FutureOr<void> _onAttendanceSaveEventFormSubmitted(
      AttendanceSaveEventFormSubmitted event,
      Emitter<AttendanceSaveState> emit) async {
    emit(state.copyWith(status: AttendanceSaveStateStatus.loading));
    try {
      AttendanceModel AttendanceModel;
      if (state.model == null) {
        AttendanceModel = AttendanceModel(
          uf: event.uf,
          city: event.city,
          name: event.name,
        );
      } else {
        AttendanceModel = state.model!.copyWith(
          uf: event.uf,
          city: event.city,
          name: event.name,
        );
      }
      String AttendanceModelId =
          await _AttendanceRepository.update(AttendanceModel);

      AttendanceModel = AttendanceModel.copyWith(id: AttendanceModelId);

      emit(state.copyWith(
          model: AttendanceModel, status: AttendanceSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: AttendanceSaveStateStatus.error,
          error: 'Erro ao salvar Attendance'));
    }
  }

  FutureOr<void> _onAttendanceSaveEventDelete(AttendanceSaveEventDelete event,
      Emitter<AttendanceSaveState> emit) async {
    try {
      emit(state.copyWith(status: AttendanceSaveStateStatus.loading));
      await _AttendanceRepository.delete(state.model!.id!);
      emit(state.copyWith(status: AttendanceSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: AttendanceSaveStateStatus.error,
          error: 'Erro ao salvar Attendance'));
    }
  }
}
