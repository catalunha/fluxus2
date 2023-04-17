import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/models/healthplan_model.dart';
import '../../../core/models/healthplantype_model.dart';
import '../../../core/repositories/healthplan_repository.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/healthplan_save_bloc.dart';
import 'bloc/healthplan_save_event.dart';
import 'bloc/healthplan_save_state.dart';

class HealthPlanSavePage extends StatelessWidget {
  final HealthPlanModel? model;

  const HealthPlanSavePage({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => HealthPlanRepository(),
      child: BlocProvider(
        create: (context) => HealthPlanSaveBloc(
          model: model,
          repository: RepositoryProvider.of<HealthPlanRepository>(context),
        ),
        child: HealthPlanSaveView(
          model: model,
        ),
      ),
    );
  }
}

class HealthPlanSaveView extends StatefulWidget {
  final HealthPlanModel? model;
  const HealthPlanSaveView({Key? key, required this.model}) : super(key: key);

  @override
  State<HealthPlanSaveView> createState() => _HealthPlanSaveViewState();
}

class _HealthPlanSaveViewState extends State<HealthPlanSaveView> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionTEC = TextEditingController();
  final _codeTEC = TextEditingController();
  bool delete = false;
  DateTime _due = DateTime.now();

  @override
  void initState() {
    super.initState();
    _descriptionTEC.text = widget.model?.description ?? "";
    _codeTEC.text = widget.model?.code ?? "";
    _due = widget.model?.due ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plano de saúde'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          if (delete) {
            context.read<HealthPlanSaveBloc>().add(
                  HealthPlanSaveEventDelete(),
                );
          } else {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              context.read<HealthPlanSaveBloc>().add(
                    HealthPlanSaveEventFormSubmitted(
                      description: _descriptionTEC.text,
                      code: _codeTEC.text,
                      due: _due,
                    ),
                  );
            }
          }
        },
      ),
      body: BlocListener<HealthPlanSaveBloc, HealthPlanSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == HealthPlanSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == HealthPlanSaveStateStatus.success) {
            Navigator.of(context).pop();
            Navigator.of(context).pop(state.model);
          }
          if (state.status == HealthPlanSaveStateStatus.loading) {
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
                      const Text('Selecione a tipo de plano *'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp =
                                    context.read<HealthPlanSaveBloc>();
                                List<HealthPlanTypeModel>? result =
                                    await Navigator.of(context).pushNamed(
                                            '/healthplantype/select',
                                            arguments: true)
                                        as List<HealthPlanTypeModel>?;
                                if (result != null) {
                                  contextTemp.add(
                                      HealthPlanSaveEventAddHealthPlanType(
                                          result[0]));
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<HealthPlanSaveBloc, HealthPlanSaveState>(
                            builder: (context, state) {
                              return Text('${state.healthPlanType?.name}');
                            },
                          ),
                        ],
                      ),
                      AppTextFormField(
                        label: 'Código *',
                        controller: _codeTEC,
                        validator:
                            Validatorless.required('Este valor é obrigatório'),
                      ),
                      AppTextFormField(
                        label: 'Descrição *',
                        controller: _descriptionTEC,
                      ),
                      const Text('Vencimento'),
                      SizedBox(
                        width: 300,
                        height: 100,
                        child: CupertinoDatePicker(
                          initialDateTime: _due,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (DateTime newDate) {
                            _due = newDate;
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
