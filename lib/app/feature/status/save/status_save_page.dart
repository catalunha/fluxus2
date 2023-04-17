import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/models/status_model.dart';
import '../../../core/repositories/status_repository.dart';
import '../../utils/app_textformfield.dart';
import '../list/bloc/status_list_bloc.dart';
import '../list/bloc/status_list_event.dart';
import 'bloc/status_save_bloc.dart';
import 'bloc/status_save_event.dart';
import 'bloc/status_save_state.dart';

class StatusSavePage extends StatelessWidget {
  final StatusModel? model;

  const StatusSavePage({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => StatusRepository(),
      child: BlocProvider(
        create: (context) => StatusSaveBloc(
            model: model,
            repository: RepositoryProvider.of<StatusRepository>(context)),
        child: StatusSaveView(
          model: model,
        ),
      ),
    );
  }
}

class StatusSaveView extends StatefulWidget {
  final StatusModel? model;
  const StatusSaveView({Key? key, required this.model}) : super(key: key);

  @override
  State<StatusSaveView> createState() => _StatusSaveViewState();
}

class _StatusSaveViewState extends State<StatusSaveView> {
  final _formKey = GlobalKey<FormState>();
  final _nameTEC = TextEditingController();
  final _descriptionTEC = TextEditingController();
  bool delete = false;
  @override
  void initState() {
    super.initState();
    _nameTEC.text = widget.model?.name ?? "";
    _descriptionTEC.text = widget.model?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.model == null ? "Criar" : "Editar"} Status'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          if (delete) {
            context.read<StatusSaveBloc>().add(
                  StatusSaveEventDelete(),
                );
          } else {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              context.read<StatusSaveBloc>().add(
                    StatusSaveEventFormSubmitted(
                      name: _nameTEC.text,
                      description: _descriptionTEC.text,
                    ),
                  );
            }
          }
        },
      ),
      body: BlocListener<StatusSaveBloc, StatusSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == StatusSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == StatusSaveStateStatus.success) {
            Navigator.of(context).pop();
            if (widget.model == null) {
              context
                  .read<StatusListBloc>()
                  .add(StatusListEventAddToList(state.model!));
            } else {
              if (delete) {
                context
                    .read<StatusListBloc>()
                    .add(StatusListEventRemoveFromList(state.model!.id!));
              } else {
                context
                    .read<StatusListBloc>()
                    .add(StatusListEventUpdateList(state.model!));
              }
            }
            Navigator.of(context).pop();
          }
          if (state.status == StatusSaveStateStatus.loading) {
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
                      AppTextFormField(
                        label: 'Descrição',
                        controller: _descriptionTEC,
                        validator:
                            Validatorless.required('Descrição é obrigatório'),
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
