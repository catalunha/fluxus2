import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/patient_model.dart';
import '../../../core/models/procedure_model.dart';
import '../../../core/models/status_model.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/attendance_repository.dart';
import '../../utils/app_icon.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/attendance_search_bloc.dart';
import 'bloc/attendance_search_event.dart';
import 'bloc/attendance_search_state.dart';
import 'list/attendance_search_list_page.dart';

class AttendanceSearchPage extends StatelessWidget {
  const AttendanceSearchPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AttendanceRepository(),
      child: BlocProvider(
        create: (context) {
          return AttendanceSearchBloc(
            repository: RepositoryProvider.of<AttendanceRepository>(context),
          );
        },
        child: const AttendanceSearchView(),
      ),
    );
  }
}

class AttendanceSearchView extends StatefulWidget {
  const AttendanceSearchView({Key? key}) : super(key: key);

  @override
  State<AttendanceSearchView> createState() => _SearchPageState();
}

class _SearchPageState extends State<AttendanceSearchView> {
  final _formKey = GlobalKey<FormState>();
  bool selectedProfessional = false;
  UserProfileModel? equalsProfessional;
  bool selectedProcedure = false;
  ProcedureModel? equalsProcedure;
  bool selectedPatient = false;
  PatientModel? equalsPatient;
  bool selectedStatus = false;
  StatusModel? equalsStatus;

  DateTime? start;
  DateTime? end;

  @override
  void initState() {
    super.initState();
    start = DateTime.now();
    end = DateTime.now().add(const Duration(days: 7));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscando atendimentos'),
      ),
      body: BlocListener<AttendanceSearchBloc, AttendanceSearchState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == AttendanceSearchStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == AttendanceSearchStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == AttendanceSearchStateStatus.loading) {
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
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                      child: Column(children: [
                        const Text('Inicio'),
                        SizedBox(
                          width: 300,
                          height: 100,
                          child: CupertinoDatePicker(
                            initialDateTime: start,
                            mode: CupertinoDatePickerMode.date,
                            onDateTimeChanged: (DateTime newDate) {
                              start = newDate;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Fim'),
                        SizedBox(
                          width: 300,
                          height: 100,
                          child: CupertinoDatePicker(
                            initialDateTime: end,
                            mode: CupertinoDatePickerMode.date,
                            onDateTimeChanged: (DateTime newDate) {
                              end = newDate;
                            },
                          ),
                        ),
                      ]),
                    ),
                    Card(
                      child: Column(children: [
                        const Text('Selecione um Status'),
                        Row(
                          children: [
                            Checkbox(
                              value: selectedStatus,
                              onChanged: (value) {
                                setState(() {
                                  selectedStatus = value!;
                                });
                              },
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      List<StatusModel>? result =
                                          await Navigator.of(context).pushNamed(
                                                  '/status/select',
                                                  arguments: true)
                                              as List<StatusModel>?;
                                      if (result != null) {
                                        setState(() {
                                          equalsStatus = result[0];
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.search),
                                  ),
                                  Text('${equalsStatus?.name}')
                                ],
                              ),
                            ),
                          ],
                        )
                      ]),
                    ),
                    Card(
                      child: Column(children: [
                        const Text('Selecione um Profissional'),
                        Row(
                          children: [
                            Checkbox(
                              value: selectedProfessional,
                              onChanged: (value) {
                                setState(() {
                                  selectedProfessional = value!;
                                });
                              },
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      List<UserProfileModel>? result =
                                          await Navigator.of(context).pushNamed(
                                                  '/userProfile/select',
                                                  arguments: true)
                                              as List<UserProfileModel>?;
                                      if (result != null) {
                                        setState(() {
                                          equalsProfessional = result[0];
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.search),
                                  ),
                                  Text('${equalsProfessional?.nickname}')
                                ],
                              ),
                            ),
                          ],
                        )
                      ]),
                    ),
                    Card(
                      child: Column(children: [
                        const Text('Selecione um Procedimento'),
                        Row(
                          children: [
                            Checkbox(
                              value: selectedProcedure,
                              onChanged: (value) {
                                setState(() {
                                  selectedProcedure = value!;
                                });
                              },
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      List<ProcedureModel>? result =
                                          await Navigator.of(context).pushNamed(
                                                  '/procedure/select',
                                                  arguments: true)
                                              as List<ProcedureModel>?;
                                      if (result != null) {
                                        setState(() {
                                          equalsProcedure = result[0];
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.search),
                                  ),
                                  Text('${equalsProcedure?.code}')
                                ],
                              ),
                            ),
                          ],
                        )
                      ]),
                    ),
                    Card(
                      child: Column(children: [
                        const Text('Selecione um Paciente'),
                        Row(
                          children: [
                            Checkbox(
                              value: selectedPatient,
                              onChanged: (value) {
                                setState(() {
                                  selectedPatient = value!;
                                });
                              },
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      List<PatientModel>? result =
                                          await Navigator.of(context).pushNamed(
                                                  '/patient/select',
                                                  arguments: true)
                                              as List<PatientModel>?;
                                      if (result != null) {
                                        setState(() {
                                          equalsPatient = result[0];
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.search),
                                  ),
                                  Text('${equalsPatient?.nickname}')
                                ],
                              ),
                            ),
                          ],
                        )
                      ]),
                    ),
                    const SizedBox(height: 70)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Executar busca',
        child: const Icon(AppIconData.search),
        onPressed: () async {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            context
                .read<AttendanceSearchBloc>()
                .add(AttendanceSearchEventFormSubmitted(
                  start: start,
                  end: end,
                  selectedStatus: selectedStatus,
                  equalsStatus: equalsStatus,
                  selectedProfessional: selectedProfessional,
                  equalsProfessional: equalsProfessional,
                  selectedProcedure: selectedProcedure,
                  equalsProcedure: equalsProcedure,
                  selectedPatient: selectedPatient,
                  equalsPatient: equalsPatient,
                ));
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<AttendanceSearchBloc>(context),
                  child: const AttendanceSearchListPage(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class SearchCardText extends StatelessWidget {
  final String title;
  final String label;
  final bool isSelected;
  final Function(bool?)? selectedOnChanged;
  final TextEditingController controller;
  const SearchCardText({
    super.key,
    required this.title,
    required this.label,
    required this.isSelected,
    required this.controller,
    this.selectedOnChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(title),
          Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: selectedOnChanged,
              ),
              Expanded(
                child: AppTextFormField(
                  label: label,
                  controller: controller,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SearchCardBool extends StatelessWidget {
  final String title;
  final String label;
  final bool isSelected;
  final Function(bool?)? selectedOnChanged;
  final bool isSelectedValue;
  final Function(bool?)? selectedValueOnChanged;
  const SearchCardBool({
    super.key,
    required this.title,
    required this.label,
    required this.isSelected,
    this.selectedOnChanged,
    required this.isSelectedValue,
    this.selectedValueOnChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(title),
          Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: selectedOnChanged,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12,
                  ),
                  child: Row(
                    children: [
                      Text(label),
                      Checkbox(
                        value: isSelectedValue,
                        onChanged: selectedValueOnChanged,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
