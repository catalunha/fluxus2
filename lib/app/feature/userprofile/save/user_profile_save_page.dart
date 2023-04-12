import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxus2/app/core/models/graduation_model.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/models/expertise_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/repositories/user_profile_repository.dart';
import '../../utils/app_import_image.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/user_profile_save_bloc.dart';
import 'bloc/user_profile_save_event.dart';
import 'bloc/user_profile_save_state.dart';

class UserProfileSavePage extends StatelessWidget {
  final UserModel userModel;
  const UserProfileSavePage({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepositoryProvider(
        create: (context) => UserProfileRepository(),
        child: BlocProvider(
          create: (context) => UserProfileSaveBloc(
              model: userModel,
              repository:
                  RepositoryProvider.of<UserProfileRepository>(context)),
          child: UserProfileSaveView(userModel: userModel),
        ),
      ),
    );
  }
}

class UserProfileSaveView extends StatefulWidget {
  final UserModel userModel;
  const UserProfileSaveView({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<UserProfileSaveView> createState() => _UserProfileSaveViewState();
}

class _UserProfileSaveViewState extends State<UserProfileSaveView> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameTec = TextEditingController();
  final _nameTec = TextEditingController();
  final _phoneTec = TextEditingController();
  final _cpfTec = TextEditingController();
  final _addressTec = TextEditingController();
  final _registerTec = TextEditingController();
  bool isFemale = true;
  DateTime _birthday = DateTime.now();

  @override
  void initState() {
    super.initState();
    _nameTec.text = widget.userModel.userProfile?.name ?? "";
    _nicknameTec.text = widget.userModel.userProfile?.nickname ?? "";
    _phoneTec.text = widget.userModel.userProfile?.phone ?? "";
    _cpfTec.text = widget.userModel.userProfile?.cpf ?? "";
    _addressTec.text = widget.userModel.userProfile?.address ?? "";
    _registerTec.text = widget.userModel.userProfile?.register ?? "";
    isFemale = widget.userModel.userProfile?.isFemale ?? true;
    _birthday = widget.userModel.userProfile?.birthday ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savear seu perfil'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            context.read<UserProfileSaveBloc>().add(
                  UserProfileSaveEventFormSubmitted(
                    name: _nameTec.text,
                    nickname: _nicknameTec.text,
                    cpf: _cpfTec.text,
                    phone: _phoneTec.text,
                    address: _addressTec.text,
                    register: _registerTec.text,
                    isFemale: isFemale,
                    birthday: _birthday,
                  ),
                );
          }
        },
      ),
      body: BlocListener<UserProfileSaveBloc, UserProfileSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == UserProfileSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == UserProfileSaveStateStatus.success) {
            Navigator.of(context).pop();
            context
                .read<AuthenticationBloc>()
                .add(AuthenticationEventUpdateUserProfile(state.user));
            Navigator.of(context).pop();
          }
          if (state.status == UserProfileSaveStateStatus.loading) {
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
                      Text(
                        'Id: ${widget.userModel.userProfile!.id}',
                      ),
                      Text(
                        'email: ${widget.userModel.userProfile!.email}',
                      ),
                      const SizedBox(height: 5),
                      AppTextFormField(
                        label: '* Seu nome curto ou apelido',
                        controller: _nicknameTec,
                        validator:
                            Validatorless.required('Nome curto é obrigatório'),
                      ),
                      AppTextFormField(
                        label: '* Seu nome',
                        controller: _nameTec,
                        validator: Validatorless.required(
                            'Nome completo é obrigatório'),
                      ),
                      AppTextFormField(
                        label: '* Seu CPF. Apenas números',
                        controller: _cpfTec,
                        validator: Validatorless.multiple([
                          Validatorless.required('CPF é obrigatório'),
                          Validatorless.cpf('Número de CPF é inválido')
                        ]),
                      ),
                      AppTextFormField(
                          label: '* Seu telefone. Formato: DDDNÚMERO',
                          controller: _phoneTec,
                          validator: Validatorless.multiple([
                            Validatorless.number(
                                'Apenas números. Formato: DDDNÚMERO'),
                            Validatorless.required('Telefone é obrigatório'),
                          ])),
                      AppTextFormField(
                        label: 'Seu endereço',
                        controller: _addressTec,
                      ),
                      AppTextFormField(
                        label: 'Seu registro no seu conselho',
                        controller: _registerTec,
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
                      AppImportImage(
                        label:
                            'Click aqui para buscar sua foto, apenas face. Padrão 3x4.',
                        imageUrl: widget.userModel.userProfile!.photo,
                        setXFile: (value) => context
                            .read<UserProfileSaveBloc>()
                            .add(UserProfileSaveEventSendXFile(xfile: value)),
                        maxHeightImage: 150,
                        maxWidthImage: 100,
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
                      const Text('Selecione uma graduação'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp =
                                    context.read<UserProfileSaveBloc>();
                                GraduationModel? result =
                                    await Navigator.of(context)
                                            .pushNamed('/graduation/select')
                                        as GraduationModel?;
                                if (result != null) {
                                  contextTemp.add(
                                    UserProfileSaveEventAddGraduation(
                                      result,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<UserProfileSaveBloc,
                              UserProfileSaveState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: state.graduationsUpdated
                                    .map(
                                      (e) => Row(
                                        children: [
                                          Text('${e.name}'),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              context
                                                  .read<UserProfileSaveBloc>()
                                                  .add(
                                                    UserProfileSaveEventRemoveGraduation(
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
                      const Text('Selecione uma especialidade'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp =
                                    context.read<UserProfileSaveBloc>();
                                ExpertiseModel? result =
                                    await Navigator.of(context)
                                            .pushNamed('/expertise/select')
                                        as ExpertiseModel?;
                                if (result != null) {
                                  contextTemp.add(
                                    UserProfileSaveEventAddExpertise(
                                      result,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<UserProfileSaveBloc,
                              UserProfileSaveState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: state.expertisesUpdated
                                    .map(
                                      (e) => Row(
                                        children: [
                                          Text('${e.name}'),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              context
                                                  .read<UserProfileSaveBloc>()
                                                  .add(
                                                    UserProfileSaveEventRemoveExpertise(
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
