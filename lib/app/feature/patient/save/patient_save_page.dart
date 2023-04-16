import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxus2/app/core/models/patient_model.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/models/healthplan_model.dart';
import '../../../core/models/region_model.dart';
import '../../../core/repositories/healthplan_repository.dart';
import '../../../core/repositories/patient_repository.dart';
import '../../utils/app_textformfield.dart';
import '../search/bloc/patient_search_bloc.dart';
import '../search/bloc/patient_search_event.dart';
import 'bloc/patient_save_bloc.dart';
import 'bloc/patient_save_event.dart';
import 'bloc/patient_save_state.dart';

class PatientSavePage extends StatelessWidget {
  final PatientModel? model;
  const PatientSavePage({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => PatientRepository(),
          ),
          RepositoryProvider(
            create: (context) => HealthPlanRepository(),
          ),
        ],
        child: BlocProvider(
          create: (context) => PatientSaveBloc(
            model: model,
            repository: RepositoryProvider.of<PatientRepository>(context),
            healthPlanRepository:
                RepositoryProvider.of<HealthPlanRepository>(context),
          ),
          child: PatientSaveView(model: model),
        ),
      ),
    );
  }
}

class PatientSaveView extends StatefulWidget {
  final PatientModel? model;
  const PatientSaveView({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  State<PatientSaveView> createState() => _PatientSaveViewState();
}

class _PatientSaveViewState extends State<PatientSaveView> {
  final _formKey = GlobalKey<FormState>();
  final _emailTec = TextEditingController();
  final _nicknameTec = TextEditingController();
  final _nameTec = TextEditingController();
  final _phoneTec = TextEditingController();
  final _cpfTec = TextEditingController();
  final _addressTec = TextEditingController();
  bool isFemale = true;
  DateTime _birthday = DateTime.now();
  bool delete = false;

  @override
  void initState() {
    super.initState();
    _emailTec.text = widget.model?.email ?? "";
    _nameTec.text = widget.model?.name ?? "";
    _nicknameTec.text = widget.model?.nickname ?? "";
    _phoneTec.text = widget.model?.phone ?? "";
    _cpfTec.text = widget.model?.cpf ?? "";
    _addressTec.text = widget.model?.address ?? "";
    isFemale = widget.model?.isFemale ?? true;
    _birthday = widget.model?.birthday ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.model == null ? "Criar" : "Editar"} Paciente'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            context.read<PatientSaveBloc>().add(
                  PatientSaveEventFormSubmitted(
                    name: _nameTec.text,
                    nickname: _nicknameTec.text,
                    cpf: _cpfTec.text,
                    phone: _phoneTec.text,
                    address: _addressTec.text,
                    isFemale: isFemale,
                    birthday: _birthday,
                  ),
                );
          }
        },
      ),
      body: BlocListener<PatientSaveBloc, PatientSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == PatientSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == PatientSaveStateStatus.success) {
            Navigator.of(context).pop();
            if (widget.model != null) {
              if (delete) {
                context
                    .read<PatientSearchBloc>()
                    .add(PatientSearchEventRemoveFromList(state.model!));
              } else {
                context
                    .read<PatientSearchBloc>()
                    .add(PatientSearchEventUpdateList(state.model!));
              }
            }
            Navigator.of(context).pop();
          }
          if (state.status == PatientSaveStateStatus.updated) {
            Navigator.of(context).pop();
          }
          if (state.status == PatientSaveStateStatus.loading) {
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
                      AppTextFormField(
                        label: 'Seu nome *',
                        controller: _nameTec,
                        validator: Validatorless.required(
                            'Nome completo é obrigatório'),
                      ),
                      AppTextFormField(
                          label: 'Seu telefone. Formato: DDDNÚMERO *',
                          controller: _phoneTec,
                          validator: Validatorless.multiple([
                            Validatorless.number(
                                'Apenas números. Formato: DDDNÚMERO'),
                            Validatorless.required('Telefone é obrigatório'),
                          ])),
                      const Divider(height: 5),
                      AppTextFormField(
                        label: 'Seu nome curto ou apelido',
                        controller: _nicknameTec,
                      ),
                      AppTextFormField(
                        label: 'email',
                        controller: _emailTec,
                        validator: Validatorless.email('Email inválido'),
                      ),
                      AppTextFormField(
                        label: 'Seu CPF. Apenas números',
                        controller: _cpfTec,
                        validator: Validatorless.multiple(
                            [Validatorless.cpf('Número de CPF é inválido')]),
                      ),
                      AppTextFormField(
                        label: 'Seu endereço completo. (Rua X, ..., CEP ..., )',
                        controller: _addressTec,
                      ),
                      const Text('Selecione a região'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp =
                                    context.read<PatientSaveBloc>();
                                RegionModel? result =
                                    await Navigator.of(context)
                                            .pushNamed('/region/select')
                                        as RegionModel?;
                                if (result != null) {
                                  contextTemp
                                      .add(PatientSaveEventAddRegion(result));
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<PatientSaveBloc, PatientSaveState>(
                            builder: (context, state) {
                              return Text(
                                  '${state.region?.uf}. ${state.region?.city}. ${state.region?.name}');
                            },
                          ),
                        ],
                      ),
                      CheckboxListTile(
                        title: const Text("Sexo feminino ?"),
                        onChanged: (value) {
                          setState(() {
                            isFemale = value ?? true;
                          });
                        },
                        value: isFemale,
                      ),
                      const SizedBox(height: 5),
                      const Text('Aniversário'),
                      SizedBox(
                        width: 300,
                        height: 100,
                        child: CupertinoDatePicker(
                          initialDateTime: _birthday,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (DateTime newDate) {
                            _birthday = newDate;
                          },
                        ),
                      ),
                      const Text('Selecione sua família'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp =
                                    context.read<PatientSaveBloc>();
                                List<PatientModel>? result =
                                    await Navigator.of(context).pushNamed(
                                            '/patient/select',
                                            arguments: false)
                                        as List<PatientModel>?;
                                if (result != null) {
                                  for (var element in result) {
                                    contextTemp.add(
                                      PatientSaveEventAddFamily(
                                        element,
                                      ),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<PatientSaveBloc, PatientSaveState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: state.familyUpdated
                                    .map(
                                      (e) => Row(
                                        children: [
                                          Text('${e.name}'),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              context
                                                  .read<PatientSaveBloc>()
                                                  .add(
                                                    PatientSaveEventRemoveFamily(
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
                          const SizedBox(width: 15)
                        ],
                      ),
                      const Text('Defina seu plano de saúde'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp =
                                    context.read<PatientSaveBloc>();
                                HealthPlanModel? result =
                                    await Navigator.of(context).pushNamed(
                                        '/healthplan/save',
                                        arguments: null) as HealthPlanModel?;
                                if (result != null) {
                                  contextTemp.add(
                                    PatientSaveEventAddHealthPlan(
                                      result,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.add)),
                          BlocBuilder<PatientSaveBloc, PatientSaveState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: state.healthPlansUpdated
                                    .map(
                                      (e) => Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () async {
                                              var contextTemp = context
                                                  .read<PatientSaveBloc>();
                                              HealthPlanModel? result =
                                                  await Navigator.of(context)
                                                          .pushNamed(
                                                              '/healthplan/save',
                                                              arguments: e)
                                                      as HealthPlanModel?;
                                              if (result != null) {
                                                contextTemp.add(
                                                  PatientSaveEventUpdateHealthPlan(
                                                    result,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          Text('${e.code}'),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              context
                                                  .read<PatientSaveBloc>()
                                                  .add(
                                                    PatientSaveEventRemoveHealthPlan(
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
                          const SizedBox(width: 15)
                        ],
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

  // Future<bool> saveProfile() async {
  //   final formValid = _formKey.currentState?.validate() ?? false;
  //   if (formValid) {
  //     await widget._userProfileController.append(
  //       nickname: _nicknameTec.text,
  //       name: _nameTec.text,
  //       phone: _phoneTec.text,
  //       cpf: _cpfTec.text,
  //       cpf: _cpfTec.text,
  //     );
  //     return true;
  //   }
  //   return false;
  // }
}
