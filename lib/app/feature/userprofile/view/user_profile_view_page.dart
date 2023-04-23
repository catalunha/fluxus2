import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/user_profile_repository.dart';
import '../../utils/app_photo_show.dart';
import '../../utils/app_text_title_value.dart';
import 'bloc/user_profile_view_bloc.dart';
import 'bloc/user_profile_view_state.dart';

class UserProfileViewPage extends StatelessWidget {
  final UserProfileModel model;
  const UserProfileViewPage({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepositoryProvider(
        create: (context) => UserProfileRepository(),
        child: BlocProvider(
          create: (context) => UserProfileViewBloc(
            model: model,
            repository: RepositoryProvider.of<UserProfileRepository>(context),
          ),
          child: UserProfileViewView(model: model),
        ),
      ),
    );
  }
}

class UserProfileViewView extends StatelessWidget {
  final UserProfileModel model;
  UserProfileViewView({
    Key? key,
    required this.model,
  }) : super(key: key);
  final dateFormat = DateFormat('dd/MM/y');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados desta pessoa')),
      body: BlocListener<UserProfileViewBloc, UserProfileViewState>(
        listener: (context, state) async {
          if (state.status == UserProfileViewStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == UserProfileViewStateStatus.updated) {
            Navigator.of(context).pop();
          }
          if (state.status == UserProfileViewStateStatus.loading) {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<UserProfileViewBloc, UserProfileViewState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppTextTitleValue(
                        title: 'Foto:',
                        value: '',
                      ),
                      AppImageShow(
                        photoUrl: state.model.photo,
                        height: 100,
                        width: 100,
                      ),
                      AppTextTitleValue(
                        title: 'E-mail: ',
                        value: state.model.email,
                      ),
                      AppTextTitleValue(
                        title: 'Nome curto: ',
                        value: state.model.nickname,
                      ),
                      AppTextTitleValue(
                        title: 'Nome completo: ',
                        value: state.model.name,
                      ),
                      AppTextTitleValue(
                        title: 'CPF: ',
                        value: state.model.cpf,
                      ),
                      AppTextTitleValue(
                        title: 'Registro: ',
                        value: state.model.register,
                      ),
                      AppTextTitleValue(
                        title: 'Telefone: ',
                        value: state.model.phone,
                      ),
                      AppTextTitleValue(
                        title: 'Endereço: ',
                        value: state.model.address,
                      ),
                      AppTextTitleValue(
                        title: 'Região: ',
                        value:
                            '${state.model.region?.uf}. ${state.model.region?.city}. ${state.model.region?.name}',
                      ),
                      AppTextTitleValue(
                        title: 'Sexo: ',
                        value: state.model.isFemale ?? true
                            ? "Feminino"
                            : "Masculino",
                      ),
                      AppTextTitleValue(
                        title: 'Acesso: ',
                        value: state.model.isActive ? "LIBERADO" : "bloqueado",
                      ),
                      AppTextTitleValue(
                        title: 'Aniversário: ',
                        value: state.model.birthday == null
                            ? '...'
                            : dateFormat.format(state.model.birthday!),
                      ),
                      AppTextTitleValue(
                        title: 'Acessa como: ',
                        value: state.model.access.join('\n'),
                      ),
                      AppTextTitleValue(
                        title: 'Cargos: ',
                        value: state.model.offices
                            ?.map((e) => e.name)
                            .toList()
                            .join(', '),
                      ),
                      AppTextTitleValue(
                        title: 'Especialidades: ',
                        value: state.model.expertises
                            ?.map((e) => e.name)
                            .toList()
                            .join(', '),
                      ),
                      AppTextTitleValue(
                        title: 'Procedimentos: ',
                        value: state.model.procedures
                            ?.map((e) => e.code)
                            .toList()
                            .join(', '),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
