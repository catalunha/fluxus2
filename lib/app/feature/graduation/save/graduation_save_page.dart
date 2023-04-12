import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/models/graduation_model.dart';
import '../../../core/repositories/graduation_repository.dart';
import '../../utils/app_textformfield.dart';
import '../list/bloc/graduation_list_bloc.dart';
import '../list/bloc/graduation_list_event.dart';
import 'bloc/graduation_save_bloc.dart';
import 'bloc/graduation_save_event.dart';
import 'bloc/graduation_save_state.dart';

class GraduationSavePage extends StatelessWidget {
  final GraduationModel? model;

  const GraduationSavePage({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => GraduationRepository(),
      child: BlocProvider(
        create: (context) => GraduationSaveBloc(
            model: model,
            repository: RepositoryProvider.of<GraduationRepository>(context)),
        child: GraduationSaveView(
          model: model,
        ),
      ),
    );
  }
}

class GraduationSaveView extends StatefulWidget {
  final GraduationModel? model;
  const GraduationSaveView({Key? key, required this.model}) : super(key: key);

  @override
  State<GraduationSaveView> createState() => _GraduationSaveViewState();
}

class _GraduationSaveViewState extends State<GraduationSaveView> {
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
            context.read<GraduationSaveBloc>().add(
                  GraduationSaveEventDelete(),
                );
          } else {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              context.read<GraduationSaveBloc>().add(
                    GraduationSaveEventFormSubmitted(
                      name: _nameTEC.text,
                    ),
                  );
            }
          }
        },
      ),
      body: BlocListener<GraduationSaveBloc, GraduationSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == GraduationSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == GraduationSaveStateStatus.success) {
            Navigator.of(context).pop();
            if (widget.model != null) {
              if (delete) {
                context
                    .read<GraduationListBloc>()
                    .add(GraduationListEventRemoveFromList(state.model!.id!));
              } else {
                context
                    .read<GraduationListBloc>()
                    .add(GraduationListEventUpdateList(state.model!));
              }
            }
            Navigator.of(context).pop();
          }
          if (state.status == GraduationSaveStateStatus.loading) {
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
