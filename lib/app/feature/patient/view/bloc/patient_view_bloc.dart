import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/patient_model.dart';
import '../../../../core/repositories/patient_repository.dart';
import '../../../../data/b4a/entity/patient_entity.dart';
import 'patient_view_event.dart';
import 'patient_view_state.dart';

class PatientViewBloc extends Bloc<PatientViewEvent, PatientViewState> {
  final PatientRepository _repository;
  PatientViewBloc({
    required PatientModel model,
    required PatientRepository repository,
  })  : _repository = repository,
        super(PatientViewState.initial(model)) {
    on<PatientViewEventStart>(_onPatientViewEventStart);
    add(PatientViewEventStart());
  }
  FutureOr<void> _onPatientViewEventStart(
      PatientViewEventStart event, Emitter<PatientViewState> emit) async {
    print('Staaaaaaaarting....');
    emit(state.copyWith(status: PatientViewStateStatus.loading));
    try {
      PatientModel? temp =
          await _repository.readById(state.model.id!, PatientEntity.allCols);
      emit(state.copyWith(model: temp, status: PatientViewStateStatus.updated));
    } catch (e) {
      //print(e);
      emit(state.copyWith(
          status: PatientViewStateStatus.error,
          error: 'Erro ao buscar dados do paciente'));
    }
  }
}
