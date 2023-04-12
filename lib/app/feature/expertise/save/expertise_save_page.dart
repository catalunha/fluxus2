import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/models/expertise_model.dart';
import '../../../core/repositories/expertise_repository.dart';
import '../../utils/app_textformfield.dart';
import '../list/bloc/expertise_list_bloc.dart';
import '../list/bloc/expertise_list_event.dart';
import 'bloc/expertise_save_bloc.dart';
import 'bloc/expertise_save_event.dart';
import 'bloc/expertise_save_state.dart';

class ExpertiseSavePage extends StatelessWidget {
  final ExpertiseModel? model;

  const ExpertiseSavePage({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ExpertiseRepository(),
      child: BlocProvider(
        create: (context) => ExpertiseSaveBloc(
            model: model,
            repository: RepositoryProvider.of<ExpertiseRepository>(context)),
        child: ExpertiseSaveView(
          model: model,
        ),
      ),
    );
  }
}

class ExpertiseSaveView extends StatefulWidget {
  final ExpertiseModel? model;
  const ExpertiseSaveView({Key? key, required this.model}) : super(key: key);

  @override
  State<ExpertiseSaveView> createState() => _ExpertiseSaveViewState();
}

class _ExpertiseSaveViewState extends State<ExpertiseSaveView> {
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
        title: const Text('Especialidade'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          if (delete) {
            context.read<ExpertiseSaveBloc>().add(
                  ExpertiseSaveEventDelete(),
                );
          } else {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              context.read<ExpertiseSaveBloc>().add(
                    ExpertiseSaveEventFormSubmitted(
                      name: _nameTEC.text,
                    ),
                  );
            }
          }
        },
      ),
      body: BlocListener<ExpertiseSaveBloc, ExpertiseSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == ExpertiseSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == ExpertiseSaveStateStatus.success) {
            Navigator.of(context).pop();
            if (widget.model != null) {
              if (delete) {
                context
                    .read<ExpertiseListBloc>()
                    .add(ExpertiseListEventRemoveFromList(state.model!.id!));
              } else {
                context
                    .read<ExpertiseListBloc>()
                    .add(ExpertiseListEventUpdateList(state.model!));
              }
            }
            Navigator.of(context).pop();
          }
          if (state.status == ExpertiseSaveStateStatus.loading) {
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
