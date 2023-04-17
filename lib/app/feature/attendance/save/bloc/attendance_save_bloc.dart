import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/attendance_model.dart';
import '../../../../core/models/healthplan_model.dart';
import '../../../../core/models/procedure_model.dart';
import '../../../../core/repositories/attendance_repository.dart';
import 'attendance_save_event.dart';
import 'attendance_save_state.dart';

class AttendanceSaveBloc
    extends Bloc<AttendanceSaveEvent, AttendanceSaveState> {
  final AttendanceRepository _repository;
  AttendanceSaveBloc({
    required AttendanceModel? model,
    required AttendanceRepository repository,
  })  : _repository = repository,
        super(AttendanceSaveState.initial(model)) {
    on<AttendanceSaveEventFormSubmitted>(_onAttendanceSaveEventFormSubmitted);
    on<AttendanceSaveEventDelete>(_onAttendanceSaveEventDelete);
    on<AttendanceSaveEventSetProfessional>(
        _onAttendanceSaveEventSetProfessional);
    on<AttendanceSaveEventSetPatient>(_onAttendanceSaveEventSetPatient);
    on<AttendanceSaveEventDuplicateProcedure>(
        _onAttendanceSaveEventDuplicateProcedure);
    on<AttendanceSaveEventRemoveProcedure>(
        _onAttendanceSaveEventRemoveProcedure);
    on<AttendanceSaveEventRemoveHealthPlan>(
        _onAttendanceSaveEventRemoveHealthPlan);
  }

  FutureOr<void> _onAttendanceSaveEventFormSubmitted(
      AttendanceSaveEventFormSubmitted event,
      Emitter<AttendanceSaveState> emit) async {
    emit(state.copyWith(status: AttendanceSaveStateStatus.loading));
    try {
      if (state.healthPlans.length == 1 && state.procedures.isNotEmpty) {
        AttendanceModel? modelTemp;
        for (var procedure in state.procedures) {
          if (state.model == null) {
            modelTemp = AttendanceModel(
              professional: state.professional,
              procedure: procedure,
              patient: state.patient,
              healthPlan: state.healthPlans[0],
              authorizationCode: event.authorizationCode,
              authorizationDateCreated: event.authorizationDateCreated,
              authorizationDateLimit: event.authorizationDateLimit,
              description: event.description,
            );
          } else {
            modelTemp = state.model!.copyWith(
              professional: state.professional,
              procedure: procedure,
              patient: state.patient,
              healthPlan: state.healthPlans[0],
              authorizationCode: event.authorizationCode,
              authorizationDateCreated: event.authorizationDateCreated,
              authorizationDateLimit: event.authorizationDateLimit,
              description: event.description,
            );
          }
          String modelId = await _repository.update(modelTemp);

          modelTemp = modelTemp.copyWith(id: modelId);
        }
        emit(state.copyWith(
            model: modelTemp, status: AttendanceSaveStateStatus.success));
      } else {
        emit(state.copyWith(
            status: AttendanceSaveStateStatus.error,
            error: 'Procedimento e Plano de saúde devem haver pelo menos um'));
      }
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
      await _repository.delete(state.model!.id!);
      emit(state.copyWith(status: AttendanceSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: AttendanceSaveStateStatus.error,
          error: 'Erro ao salvar Attendance'));
    }
  }

  FutureOr<void> _onAttendanceSaveEventSetProfessional(
      AttendanceSaveEventSetProfessional event,
      Emitter<AttendanceSaveState> emit) {
    emit(state.copyWith(
      professional: event.model,
      procedures: event.model.procedures,
    ));
  }

  FutureOr<void> _onAttendanceSaveEventSetPatient(
      AttendanceSaveEventSetPatient event, Emitter<AttendanceSaveState> emit) {
    emit(state.copyWith(
      patient: event.model,
      healthPlans: event.model.healthPlans,
    ));
  }

  FutureOr<void> _onAttendanceSaveEventDuplicateProcedure(
      AttendanceSaveEventDuplicateProcedure event,
      Emitter<AttendanceSaveState> emit) {
    // List<ProcedureModel> temp = [...state.procedures];
    // temp.add(event.model);
    // emit(state.copyWith(procedures: temp));
    List<ProcedureModel> temp = [...state.procedures];
    var index = temp.indexOf(event.model);
    temp.insert(index, event.model);
    emit(state.copyWith(procedures: temp));
  }

  FutureOr<void> _onAttendanceSaveEventRemoveProcedure(
      AttendanceSaveEventRemoveProcedure event,
      Emitter<AttendanceSaveState> emit) {
    List<ProcedureModel> temp = [...state.procedures];
    temp.remove(event.model);
    // temp.removeWhere((element) => element.hashCode == event.model.hashCode);
    emit(state.copyWith(procedures: temp));
  }

  FutureOr<void> _onAttendanceSaveEventRemoveHealthPlan(
      AttendanceSaveEventRemoveHealthPlan event,
      Emitter<AttendanceSaveState> emit) {
    List<HealthPlanModel> temp = [...state.healthPlans];
    temp.removeWhere((element) => element.id == event.model.id);
    emit(state.copyWith(healthPlans: temp));
  }
}
