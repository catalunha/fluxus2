import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/models/user_model.dart';
import '../../../core/repositories/user_profile_repository.dart';
import '../../utils/app_import_image.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/user_profile_edit_bloc.dart';

class UserProfileEditPage extends StatelessWidget {
  final UserModel userModel;
  const UserProfileEditPage({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepositoryProvider(
        create: (context) => UserProfileRepository(),
        child: BlocProvider(
          create: (context) => UserProfileEditBloc(
              userModel: userModel,
              userProfileRepository:
                  RepositoryProvider.of<UserProfileRepository>(context)),
          child: UserProfileEditView(userModel: userModel),
        ),
      ),
    );
  }
}

class UserProfileEditView extends StatefulWidget {
  final UserModel userModel;
  const UserProfileEditView({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<UserProfileEditView> createState() => _UserProfileEditViewState();
}

class _UserProfileEditViewState extends State<UserProfileEditView> {
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
        title: const Text('Editar seu perfil'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            context.read<UserProfileEditBloc>().add(
                  UserProfileEditEventFormSubmitted(
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
      body: BlocListener<UserProfileEditBloc, UserProfileEditState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == UserProfileEditStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == UserProfileEditStateStatus.success) {
            Navigator.of(context).pop();
            context
                .read<AuthenticationBloc>()
                .add(AuthenticationEventUpdateUserProfile(state.user));
            Navigator.of(context).pop();
          }
          if (state.status == UserProfileEditStateStatus.loading) {
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
                            .read<UserProfileEditBloc>()
                            .add(UserProfileEditEventSendXFile(xfile: value)),
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
