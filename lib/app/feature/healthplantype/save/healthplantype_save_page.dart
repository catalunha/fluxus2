import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/models/healthplantype_model.dart';
import '../../../core/repositories/healthplantype_repository.dart';
import '../../utils/app_textformfield.dart';
import '../list/bloc/graduation_list_bloc.dart';
import '../list/bloc/healthplantype_list_event.dart';
import 'bloc/healthplantype_save_bloc.dart';
import 'bloc/healthplantype_save_event.dart';
import 'bloc/healthplantype_save_state.dart';

class HealthPlanTypeSavePage extends StatelessWidget {
  final HealthPlanTypeModel? model;

  const HealthPlanTypeSavePage({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => HealthPlanTypeRepository(),
      child: BlocProvider(
        create: (context) => HealthPlanTypeSaveBloc(
            model: model,
            repository:
                RepositoryProvider.of<HealthPlanTypeRepository>(context)),
        child: HealthPlanTypeSaveView(
          model: model,
        ),
      ),
    );
  }
}

class HealthPlanTypeSaveView extends StatefulWidget {
  final HealthPlanTypeModel? model;
  const HealthPlanTypeSaveView({Key? key, required this.model})
      : super(key: key);

  @override
  State<HealthPlanTypeSaveView> createState() => _HealthPlanTypeSaveViewState();
}

class _HealthPlanTypeSaveViewState extends State<HealthPlanTypeSaveView> {
  final _formKey = GlobalKey<FormState>();
  final _nameTEC = TextEditingController();
  bool delete = false;
  @override
  void initState() {
    super.initState();
    _nameTEC.text = widget.model?.name ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graduação'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          if (delete) {
            context.read<HealthPlanTypeSaveBloc>().add(
                  HealthPlanTypeSaveEventDelete(),
                );
          } else {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              context.read<HealthPlanTypeSaveBloc>().add(
                    HealthPlanTypeSaveEventFormSubmitted(
                      name: _nameTEC.text,
                    ),
                  );
            }
          }
        },
      ),
      body: BlocListener<HealthPlanTypeSaveBloc, HealthPlanTypeSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == HealthPlanTypeSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == HealthPlanTypeSaveStateStatus.success) {
            Navigator.of(context).pop();
            if (widget.model != null) {
              if (delete) {
                context.read<HealthPlanTypeListBloc>().add(
                    HealthPlanTypeListEventRemoveFromList(state.model!.id!));
              } else {
                context
                    .read<HealthPlanTypeListBloc>()
                    .add(HealthPlanTypeListEventUpdateList(state.model!));
              }
            }
            Navigator.of(context).pop();
          }
          if (state.status == HealthPlanTypeSaveStateStatus.loading) {
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
                      AppTextFormField(
                        label: 'Nome',
                        controller: _nameTEC,
                        validator: Validatorless.required('Nome é obrigatório'),
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
