import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/models/region_model.dart';
import '../../../core/repositories/region_repository.dart';
import '../../utils/app_textformfield.dart';
import '../search/bloc/region_search_bloc.dart';
import '../search/bloc/region_search_event.dart';
import 'bloc/region_save_bloc.dart';
import 'bloc/region_save_event.dart';
import 'bloc/region_save_state.dart';

class RegionSavePage extends StatelessWidget {
  final RegionModel? model;

  const RegionSavePage({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => RegionRepository(),
      child: BlocProvider(
        create: (context) {
          return RegionSaveBloc(
            regionModel: model,
            regionRepository: RepositoryProvider.of<RegionRepository>(context),
          );
        },
        child: RegionSaveView(
          model: model,
        ),
      ),
    );
  }
}

class RegionSaveView extends StatefulWidget {
  final RegionModel? model;
  const RegionSaveView({Key? key, required this.model}) : super(key: key);

  @override
  State<RegionSaveView> createState() => _RegionSaveViewState();
}

class _RegionSaveViewState extends State<RegionSaveView> {
  final _formKey = GlobalKey<FormState>();
  final _ufTEC = TextEditingController();
  final _cityTEC = TextEditingController();
  final _nameTEC = TextEditingController();
  bool delete = false;
  @override
  void initState() {
    super.initState();
    _ufTEC.text = widget.model?.uf ?? "";
    _cityTEC.text = widget.model?.city ?? "";
    _nameTEC.text = widget.model?.name ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.model == null ? "Criar" : "Editar"} Região'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          if (delete) {
            context.read<RegionSaveBloc>().add(
                  RegionSaveEventDelete(),
                );
          } else {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              context.read<RegionSaveBloc>().add(
                    RegionSaveEventFormSubmitted(
                      uf: _ufTEC.text,
                      city: _cityTEC.text,
                      name: _nameTEC.text,
                    ),
                  );
            }
          }
        },
      ),
      body: BlocListener<RegionSaveBloc, RegionSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == RegionSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == RegionSaveStateStatus.success) {
            Navigator.of(context).pop();
            if (widget.model != null) {
              if (delete) {
                context
                    .read<RegionSearchBloc>()
                    .add(RegionSearchEventRemoveFromList(state.model!.id!));
              } else {
                context
                    .read<RegionSearchBloc>()
                    .add(RegionSearchEventUpdateList(state.model!));
              }
            }
            Navigator.of(context).pop();
          }
          if (state.status == RegionSaveStateStatus.loading) {
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
                        label: 'Estado *',
                        controller: _ufTEC,
                        validator:
                            Validatorless.required('Estado é obrigatório'),
                      ),
                      AppTextFormField(
                        label: 'Cidade *',
                        controller: _cityTEC,
                        validator:
                            Validatorless.required('Cidade é obrigatório'),
                      ),
                      AppTextFormField(
                        label:
                            'Nome * (Centro, Setor X, Bairro Y, Quadras A B C, etc)',
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
