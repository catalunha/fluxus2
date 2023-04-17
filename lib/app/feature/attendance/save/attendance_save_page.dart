import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/attendance_model.dart';
import '../../../core/models/patient_model.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/attendance_repository.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/attendance_save_bloc.dart';
import 'bloc/attendance_save_event.dart';
import 'bloc/attendance_save_state.dart';

class AttendanceSavePage extends StatelessWidget {
  final AttendanceModel? model;

  const AttendanceSavePage({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AttendanceRepository(),
      child: BlocProvider(
        create: (context) => AttendanceSaveBloc(
          model: model,
          repository: RepositoryProvider.of<AttendanceRepository>(context),
        ),
        child: AttendanceSaveView(
          model: model,
        ),
      ),
    );
  }
}

class AttendanceSaveView extends StatefulWidget {
  final AttendanceModel? model;
  const AttendanceSaveView({Key? key, required this.model}) : super(key: key);

  @override
  State<AttendanceSaveView> createState() => _AttendanceSaveViewState();
}

class _AttendanceSaveViewState extends State<AttendanceSaveView> {
  final _formKey = GlobalKey<FormState>();
  final _authorizationCodeTEC = TextEditingController();
  DateTime _authorizationDateCreated = DateTime.now();
  DateTime _authorizationDateLimit = DateTime.now();
  final _descriptionTEC = TextEditingController();
  bool delete = false;
  @override
  void initState() {
    super.initState();
    _authorizationCodeTEC.text = widget.model?.authorizationCode ?? "";
    _authorizationDateCreated =
        widget.model?.authorizationDateCreated ?? DateTime.now();
    _authorizationDateLimit = widget.model?.authorizationDateLimit ??
        DateTime.now().add(const Duration(days: 30));
    _descriptionTEC.text = widget.model?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.model == null ? "Criar" : "Editar"} Atendimento'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          if (delete) {
            context.read<AttendanceSaveBloc>().add(
                  AttendanceSaveEventDelete(),
                );
          } else {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              context.read<AttendanceSaveBloc>().add(
                    AttendanceSaveEventFormSubmitted(
                      authorizationCode: _authorizationCodeTEC.text,
                      authorizationDateCreated: _authorizationDateCreated,
                      authorizationDateLimit: _authorizationDateLimit,
                      description: _descriptionTEC.text,
                    ),
                  );
            }
          }
        },
      ),
      body: BlocListener<AttendanceSaveBloc, AttendanceSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == AttendanceSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == AttendanceSaveStateStatus.success) {
            Navigator.of(context).pop();
            // if (widget.model != null) {
            //   if (delete) {
            //     context
            //         .read<AttendanceSearchBloc>()
            //         .add(AttendanceSearchEventRemoveFromList(state.model!.id!));
            //   } else {
            //     context
            //         .read<AttendanceSearchBloc>()
            //         .add(AttendanceSearchEventUpdateList(state.model!));
            //   }
            // }
            Navigator.of(context).pop();
          }
          if (state.status == AttendanceSaveStateStatus.updated) {
            Navigator.of(context).pop();
          }
          if (state.status == AttendanceSaveStateStatus.loading) {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
        },
        child: Center(
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      const Text('Selecione um Profissional *'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp =
                                    context.read<AttendanceSaveBloc>();
                                UserProfileModel? result =
                                    await Navigator.of(context)
                                            .pushNamed('/userProfile/select')
                                        as UserProfileModel?;
                                if (result != null) {
                                  contextTemp.add(
                                      AttendanceSaveEventSetProfessional(
                                          result));
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<AttendanceSaveBloc, AttendanceSaveState>(
                            builder: (context, state) {
                              return Text('${state.professional?.name}');
                            },
                          ),
                        ],
                      ),
                      const Text('Selecione os procedimentos *'),
                      BlocBuilder<AttendanceSaveBloc, AttendanceSaveState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: state.procedures
                                .map(
                                  (e) => Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                            Icons.control_point_duplicate),
                                        onPressed: () {
                                          context
                                              .read<AttendanceSaveBloc>()
                                              .add(
                                                AttendanceSaveEventDuplicateProcedure(
                                                  e,
                                                ),
                                              );
                                        },
                                      ),
                                      Text('${e.code}'),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          context
                                              .read<AttendanceSaveBloc>()
                                              .add(
                                                AttendanceSaveEventRemoveProcedure(
                                                  e,
                                                ),
                                              );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                      const Text('Selecione um Paciente *'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp =
                                    context.read<AttendanceSaveBloc>();
                                PatientModel? result =
                                    await Navigator.of(context)
                                            .pushNamed('/patient/select')
                                        as PatientModel?;
                                if (result != null) {
                                  contextTemp.add(
                                      AttendanceSaveEventSetPatient(result));
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<AttendanceSaveBloc, AttendanceSaveState>(
                            builder: (context, state) {
                              return Text('${state.patient?.name}');
                            },
                          ),
                        ],
                      ),
                      const Text('Selecione um plano de saúde *'),
                      BlocBuilder<AttendanceSaveBloc, AttendanceSaveState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: state.healthPlans
                                .map(
                                  (e) => Row(
                                    children: [
                                      Text('${e.code}'),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          context
                                              .read<AttendanceSaveBloc>()
                                              .add(
                                                AttendanceSaveEventRemoveHealthPlan(
                                                  e,
                                                ),
                                              );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                      AppTextFormField(
                        label: 'Número da autorização',
                        controller: _authorizationCodeTEC,
                      ),
                      const Text('Data da criação desta autorização'),
                      SizedBox(
                        width: 300,
                        height: 100,
                        child: CupertinoDatePicker(
                          initialDateTime: _authorizationDateCreated,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (DateTime newDate) {
                            _authorizationDateCreated = newDate;
                          },
                        ),
                      ),
                      const Text('Data limite desta autorização'),
                      SizedBox(
                        width: 300,
                        height: 100,
                        child: CupertinoDatePicker(
                          initialDateTime: _authorizationDateLimit,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (DateTime newDate) {
                            _authorizationDateLimit = newDate;
                          },
                        ),
                      ),
                      if (widget.model != null)
                        CheckboxListTile(
                          tileColor: delete ? Colors.red : null,
                          title: const Text("Apagar este cadastro ?"),
                          onChanged: (value) {
                            setState(() {
                              delete = value ?? false;
                            });
                          },
                          value: delete,
                        ),
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
