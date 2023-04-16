import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/models/room_model.dart';
import '../../../core/repositories/room_repository.dart';
import '../../utils/app_textformfield.dart';
import '../list/bloc/room_list_bloc.dart';
import '../list/bloc/room_list_event.dart';
import 'bloc/room_save_bloc.dart';
import 'bloc/room_save_event.dart';
import 'bloc/room_save_state.dart';

class RoomSavePage extends StatelessWidget {
  final RoomModel? model;

  const RoomSavePage({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => RoomRepository(),
      child: BlocProvider(
        create: (context) => RoomSaveBloc(
            model: model,
            repository: RepositoryProvider.of<RoomRepository>(context)),
        child: RoomSaveView(
          model: model,
        ),
      ),
    );
  }
}

class RoomSaveView extends StatefulWidget {
  final RoomModel? model;
  const RoomSaveView({Key? key, required this.model}) : super(key: key);

  @override
  State<RoomSaveView> createState() => _RoomSaveViewState();
}

class _RoomSaveViewState extends State<RoomSaveView> {
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
            context.read<RoomSaveBloc>().add(
                  RoomSaveEventDelete(),
                );
          } else {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              context.read<RoomSaveBloc>().add(
                    RoomSaveEventFormSubmitted(
                      name: _nameTEC.text,
                    ),
                  );
            }
          }
        },
      ),
      body: BlocListener<RoomSaveBloc, RoomSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == RoomSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == RoomSaveStateStatus.success) {
            Navigator.of(context).pop();
            if (widget.model == null) {
              context
                  .read<RoomListBloc>()
                  .add(RoomListEventAddToList(state.model!));
            } else {
              if (delete) {
                context
                    .read<RoomListBloc>()
                    .add(RoomListEventRemoveFromList(state.model!.id!));
              } else {
                context
                    .read<RoomListBloc>()
                    .add(RoomListEventUpdateList(state.model!));
              }
            }
            Navigator.of(context).pop();
          }
          if (state.status == RoomSaveStateStatus.loading) {
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
