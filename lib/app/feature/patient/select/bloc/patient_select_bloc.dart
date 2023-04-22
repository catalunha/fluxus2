import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/patient_model.dart';
import '../../../../core/repositories/patient_repository.dart';
import '../../../../data/b4a/entity/patient_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'patient_select_event.dart';
import 'patient_select_state.dart';

class PatientSelectBloc extends Bloc<PatientSelectEvent, PatientSelectState> {
  final PatientRepository _repository;
  PatientSelectBloc({
    required PatientRepository repository,
    required bool isSingleValue,
  })  : _repository = repository,
        super(PatientSelectState.initial(isSingleValue)) {
    on<PatientSelectEventStartQuery>(_onPatientSelectEventStartQuery);
    on<PatientSelectEventPreviousPage>(_onPatientSelectEventPreviousPage);
    on<PatientSelectEventNextPage>(_onPatientSelectEventNextPage);
    on<PatientSelectEventFormSubmitted>(_onPatientSelectEventFormSubmitted);
    on<PatientSelectEventUpdateSelectedValues>(
        _onPatientSelectEventUpdateSelectedValues);
    add(PatientSelectEventStartQuery());
  }
  static final List<String> _cols = [
    PatientEntity.name,
    PatientEntity.healthPlans
  ];

  FutureOr<void> _onPatientSelectEventStartQuery(
      PatientSelectEventStartQuery event,
      Emitter<PatientSelectState> emit) async {
    emit(state.copyWith(
      status: PatientSelectStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(PatientEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(PatientEntity.className));

      query.orderByAscending('name');
      List<PatientModel> listGet = await _repository.list(
          query, Pagination(page: state.page, limit: state.limit), _cols);

      emit(state.copyWith(
        status: PatientSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: PatientSelectStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onPatientSelectEventPreviousPage(
      PatientSelectEventPreviousPage event,
      Emitter<PatientSelectState> emit) async {
    emit(
      state.copyWith(
        status: PatientSelectStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<PatientModel> listGet = await _repository.list(
          state.query, Pagination(page: state.page, limit: state.limit), _cols);
      if (state.page == 1) {
        emit(
          state.copyWith(
            page: 1,
            firstPage: true,
            lastPage: false,
          ),
        );
      }
      emit(state.copyWith(
        status: PatientSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: PatientSelectStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onPatientSelectEventNextPage(PatientSelectEventNextPage event,
      Emitter<PatientSelectState> emit) async {
    emit(
      state.copyWith(status: PatientSelectStateStatus.loading),
    );
    List<PatientModel> listGet = await _repository.list(state.query,
        Pagination(page: state.page + 1, limit: state.limit), _cols);
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: PatientSelectStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: PatientSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onPatientSelectEventFormSubmitted(
      PatientSelectEventFormSubmitted event, Emitter<PatientSelectState> emit) {
    if (event.name.isEmpty) {
      emit(state.copyWith(listFiltered: state.list));
    } else {
      List<PatientModel> listTemp;
      listTemp = state.list.where((e) => e.name!.contains(event.name)).toList();
      emit(state.copyWith(listFiltered: listTemp));
    }
  }

  FutureOr<void> _onPatientSelectEventUpdateSelectedValues(
      PatientSelectEventUpdateSelectedValues event,
      Emitter<PatientSelectState> emit) {
    int index =
        state.selectedValues.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<PatientModel> temp = [...state.selectedValues];
      temp.removeAt(index);
      emit(state.copyWith(selectedValues: temp));
    } else {
      List<PatientModel> temp = [...state.selectedValues];
      temp.add(event.model);
      emit(state.copyWith(selectedValues: temp));
    }
  }
}
