import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/models/office_model.dart';
import '../../../core/repositories/office_repository.dart';
import '../../utils/app_textformfield.dart';
import '../list/bloc/office_list_bloc.dart';
import '../list/bloc/office_list_event.dart';
import 'bloc/office_save_bloc.dart';
import 'bloc/office_save_event.dart';
import 'bloc/office_save_state.dart';

class OfficeSavePage extends StatelessWidget {
  final OfficeModel? model;

  const OfficeSavePage({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => OfficeRepository(),
      child: BlocProvider(
        create: (context) => OfficeSaveBloc(
            model: model,
            repository: RepositoryProvider.of<OfficeRepository>(context)),
        child: OfficeSaveView(
          model: model,
        ),
      ),
    );
  }
}

class OfficeSaveView extends StatefulWidget {
  final OfficeModel? model;
  const OfficeSaveView({Key? key, required this.model}) : super(key: key);

  @override
  State<OfficeSaveView> createState() => _OfficeSaveViewState();
}

class _OfficeSaveViewState extends State<OfficeSaveView> {
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
        title: Text('${widget.model == null ? "Criar" : "Editar"} Graduação'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          if (delete) {
            context.read<OfficeSaveBloc>().add(
                  OfficeSaveEventDelete(),
                );
          } else {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              context.read<OfficeSaveBloc>().add(
                    OfficeSaveEventFormSubmitted(
                      name: _nameTEC.text,
                    ),
                  );
            }
          }
        },
      ),
      body: BlocListener<OfficeSaveBloc, OfficeSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == OfficeSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == OfficeSaveStateStatus.success) {
            Navigator.of(context).pop();
            if (widget.model == null) {
              context
                  .read<OfficeListBloc>()
                  .add(OfficeListEventAddToList(state.model!));
            } else {
              if (delete) {
                context
                    .read<OfficeListBloc>()
                    .add(OfficeListEventRemoveFromList(state.model!.id!));
              } else {
                context
                    .read<OfficeListBloc>()
                    .add(OfficeListEventUpdateList(state.model!));
              }
            }
            Navigator.of(context).pop();
          }
          if (state.status == OfficeSaveStateStatus.loading) {
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
