import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/attendance_model.dart';
import '../../../../core/repositories/attendance_repository.dart';
import '../../../../data/b4a/entity/attendance_entity.dart';
import 'attendance_view_event.dart';
import 'attendance_view_state.dart';

class AttendanceViewBloc
    extends Bloc<AttendanceViewEvent, AttendanceViewState> {
  final AttendanceRepository _repository;
  AttendanceViewBloc({
    required AttendanceModel model,
    required AttendanceRepository repository,
  })  : _repository = repository,
        super(AttendanceViewState.initial(model)) {
    on<AttendanceViewEventStart>(_onAttendanceViewEventStart);
    add(AttendanceViewEventStart());
  }
  List<String> cols = [
    ...AttendanceEntity.singleCols,
    ...AttendanceEntity.selectedCols([
      'healthPlan.healthPlanType',
    ]),
  ];
  FutureOr<void> _onAttendanceViewEventStart(
      AttendanceViewEventStart event, Emitter<AttendanceViewState> emit) async {
    emit(state.copyWith(status: AttendanceViewStateStatus.loading));
    try {
      AttendanceModel? temp = await _repository.readById(state.model.id!, cols);
      emit(state.copyWith(
          model: temp, status: AttendanceViewStateStatus.updated));
    } catch (e) {
      //print(e);
      emit(state.copyWith(
          status: AttendanceViewStateStatus.error,
          error: 'Erro ao buscar dados do paciente'));
    }
  }
}
