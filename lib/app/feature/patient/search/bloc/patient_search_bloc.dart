import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/patient_model.dart';
import '../../../../core/repositories/patient_repository.dart';
import '../../../../data/b4a/entity/patient_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'patient_search_event.dart';
import 'patient_search_state.dart';

class PatientSearchBloc extends Bloc<PatientSearchEvent, PatientSearchState> {
  final PatientRepository _userProfileRepository;

  PatientSearchBloc({required PatientRepository userProfileRepository})
      : _userProfileRepository = userProfileRepository,
        super(PatientSearchState.initial()) {
    on<PatientSearchEventFormSubmitted>(_onPatientSearchEventFormSubmitted);
    on<PatientSearchEventNextPage>(_onPatientSearchEventNextPage);
    on<PatientSearchEventPreviousPage>(_onPatientSearchEventPreviousPage);
    on<PatientSearchEventUpdateList>(_onPatientSearchEventUpdateList);
    on<PatientSearchEventRemoveFromList>(_onPatientSearchEventRemoveFromList);
  }
  // static final List<String> _cols = ['name'];
  // static final List<String> _cols = ['name', 'region'];
  static final List<String> _cols = PatientEntity.getAllCols();
  FutureOr<void> _onPatientSearchEventFormSubmitted(
      PatientSearchEventFormSubmitted event,
      Emitter<PatientSearchState> emit) async {
    emit(state.copyWith(
      status: PatientSearchStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(PatientEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(PatientEntity.className));

      if (event.nameContainsBool) {
        query.whereContains('name', event.nameContainsString);
      }

      if (event.phoneEqualToBool) {
        query.whereEqualTo('phone', event.phoneEqualToString);
      }
      query.orderByDescending('updatedAt');
      List<PatientModel> listGet = await _userProfileRepository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
        _cols,
      );
      emit(state.copyWith(
        status: PatientSearchStateStatus.success,
        list: listGet,
        query: query,
      ));
    } catch (_) {
      emit(
        state.copyWith(
            status: PatientSearchStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onPatientSearchEventUpdateList(
      PatientSearchEventUpdateList event, Emitter<PatientSearchState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<PatientModel> temp = [...state.list];
      temp.replaceRange(index, index + 1, [event.model]);
      emit(state.copyWith(list: temp));
    }
  }

  FutureOr<void> _onPatientSearchEventRemoveFromList(
      PatientSearchEventRemoveFromList event,
      Emitter<PatientSearchState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<PatientModel> temp = [...state.list];
      temp.removeAt(index);
      emit(state.copyWith(list: temp));
    }
  }

  FutureOr<void> _onPatientSearchEventPreviousPage(
      PatientSearchEventPreviousPage event,
      Emitter<PatientSearchState> emit) async {
    emit(
      state.copyWith(
        status: PatientSearchStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<PatientModel> listGet = await _userProfileRepository.list(
        state.query,
        Pagination(page: state.page, limit: state.limit),
        _cols,
      );
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
        status: PatientSearchStateStatus.success,
        list: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: PatientSearchStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onPatientSearchEventNextPage(PatientSearchEventNextPage event,
      Emitter<PatientSearchState> emit) async {
    emit(
      state.copyWith(status: PatientSearchStateStatus.loading),
    );
    List<PatientModel> listGet = await _userProfileRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
      _cols,
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: PatientSearchStateStatus.success,
        // firstPage: false,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: PatientSearchStateStatus.success,
        list: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }
}
