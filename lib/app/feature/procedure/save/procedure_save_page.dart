import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/models/expertise_model.dart';
import '../../../core/models/procedure_model.dart';
import '../../../core/repositories/procedure_repository.dart';
import '../../utils/app_textformfield.dart';
import '../search/bloc/procedure_search_bloc.dart';
import '../search/bloc/procedure_search_event.dart';
import 'bloc/procedure_save_bloc.dart';
import 'bloc/procedure_save_event.dart';
import 'bloc/procedure_save_state.dart';

class ProcedureSavePage extends StatelessWidget {
  final ProcedureModel? model;

  const ProcedureSavePage({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ProcedureRepository(),
      child: BlocProvider(
        create: (context) => ProcedureSaveBloc(
          model: model,
          repository: RepositoryProvider.of<ProcedureRepository>(context),
        ),
        child: ProcedureSaveView(
          model: model,
        ),
      ),
    );
  }
}

class ProcedureSaveView extends StatefulWidget {
  final ProcedureModel? model;
  const ProcedureSaveView({Key? key, required this.model}) : super(key: key);

  @override
  State<ProcedureSaveView> createState() => _ProcedureSaveViewState();
}

class _ProcedureSaveViewState extends State<ProcedureSaveView> {
  final _formKey = GlobalKey<FormState>();
  final _nameTEC = TextEditingController();
  final _codeTEC = TextEditingController();
  final _costTEC = TextEditingController();
  bool delete = false;
  @override
  void initState() {
    super.initState();
    _nameTEC.text = widget.model?.name ?? "";
    _codeTEC.text = widget.model?.code ?? "";
    _costTEC.text = widget.model?.cost?.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Procedimento'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          if (delete) {
            context.read<ProcedureSaveBloc>().add(
                  ProcedureSaveEventDelete(),
                );
          } else {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              context.read<ProcedureSaveBloc>().add(
                    ProcedureSaveEventFormSubmitted(
                      name: _nameTEC.text,
                      code: _codeTEC.text,
                      cost: double.tryParse(_costTEC.text),
                    ),
                  );
            }
          }
        },
      ),
      body: BlocListener<ProcedureSaveBloc, ProcedureSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == ProcedureSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == ProcedureSaveStateStatus.success) {
            Navigator.of(context).pop();
            if (widget.model != null) {
              if (delete) {
                context
                    .read<ProcedureSearchBloc>()
                    .add(ProcedureSearchEventRemoveFromList(state.model!.id!));
              } else {
                context
                    .read<ProcedureSearchBloc>()
                    .add(ProcedureSearchEventUpdateList(state.model!));
              }
            }
            Navigator.of(context).pop();
          }
          if (state.status == ProcedureSaveStateStatus.loading) {
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
                      const Text('Selecione a especialidade *'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp =
                                    context.read<ProcedureSaveBloc>();
                                ExpertiseModel? result =
                                    await Navigator.of(context)
                                            .pushNamed('/expertise/select')
                                        as ExpertiseModel?;
                                if (result != null) {
                                  contextTemp.add(
                                      ProcedureSaveEventAddExpertise(result));
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<ProcedureSaveBloc, ProcedureSaveState>(
                            builder: (context, state) {
                              return Text('${state.expertise?.name}');
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
                        label: 'Nome *',
                        controller: _nameTEC,
                        validator:
                            Validatorless.required('Este valor é obrigatório'),
                      ),
                      AppTextFormField(
                        label: 'Custo *',
                        controller: _costTEC,
                        validator:
                            Validatorless.required('Este valor é obrigatório'),
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
