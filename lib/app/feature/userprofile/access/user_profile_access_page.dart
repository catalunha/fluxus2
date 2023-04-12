import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/expertise_model.dart';
import '../../../core/models/graduation_model.dart';
import '../../../core/models/procedure_model.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/user_profile_repository.dart';
import '../../utils/app_photo_show.dart';
import '../../utils/app_text_title_value.dart';
import '../search/bloc/user_profile_search_bloc.dart';
import '../search/bloc/user_profile_search_event.dart';
import 'bloc/user_profile_access_bloc.dart';
import 'bloc/user_profile_access_event.dart';
import 'bloc/user_profile_access_state.dart';

class UserProfileAccessPage extends StatelessWidget {
  final UserProfileModel userProfileModel;
  const UserProfileAccessPage({
    Key? key,
    required this.userProfileModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepositoryProvider(
        create: (context) => UserProfileRepository(),
        child: BlocProvider(
          create: (context) => UserProfileAccessBloc(
              model: userProfileModel,
              repository:
                  RepositoryProvider.of<UserProfileRepository>(context)),
          child: UserProfileAccessView(userProfileModel: userProfileModel),
        ),
      ),
    );
  }
}

class UserProfileAccessView extends StatefulWidget {
  final UserProfileModel userProfileModel;

  const UserProfileAccessView({Key? key, required this.userProfileModel})
      : super(key: key);

  @override
  State<UserProfileAccessView> createState() => _UserProfileAccessViewState();
}

class _UserProfileAccessViewState extends State<UserProfileAccessView> {
  final _formKey = GlobalKey<FormState>();
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    isActive = widget.userProfileModel.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar este operador'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            context.read<UserProfileAccessBloc>().add(
                  UserProfileAccessEventFormSubmitted(
                    isActive: isActive,
                  ),
                );
          }
        },
      ),
      body: BlocListener<UserProfileAccessBloc, UserProfileAccessState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == UserProfileAccessStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }

          if (state.status == UserProfileAccessStateStatus.success) {
            Navigator.of(context).pop();
            context
                .read<UserProfileSearchBloc>()
                .add(UserProfileSearchEventUpdateList(state.model));
            Navigator.of(context).pop();
          }
          if (state.status == UserProfileAccessStateStatus.loading) {
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
                      // Text(
                      //   'Id: ${widget._userProfileAccessController.userProfile!.id}',
                      // ),
                      const SizedBox(height: 5),
                      AppImageShow(
                        photoUrl: widget.userProfileModel.photo,
                      ),
                      AppTextTitleValue(
                        title: 'Email: ',
                        value: widget.userProfileModel.email,
                        inColumn: true,
                      ),
                      AppTextTitleValue(
                        inColumn: true,
                        title: 'Nome: ',
                        value: '${widget.userProfileModel.name}',
                      ),
                      AppTextTitleValue(
                        title: 'Telefone: ',
                        value: '${widget.userProfileModel.phone}',
                      ),

                      AppTextTitleValue(
                        title: 'CPF: ',
                        value: '${widget.userProfileModel.cpf}',
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      CheckboxListTile(
                        title: const Text("* Liberar acesso ?"),
                        value: isActive,
                        onChanged: (value) {
                          setState(() {
                            isActive = value ?? false;
                          });
                        },
                      ),
                      const Text(
                          'Marque as opções de acesso para este usuário.'),
                      Wrap(
                        children: [
                          accessSelect('Admin', 'admin'),
                          accessSelect('Secretaria', 'sec'),
                          accessSelect('Profissional', 'prof'),
                          accessSelect('Financeiro', 'fin'),
                        ],
                      ),
                      const Text('Selecione as graduações'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp =
                                    context.read<UserProfileAccessBloc>();
                                GraduationModel? result =
                                    await Navigator.of(context)
                                            .pushNamed('/graduation/select')
                                        as GraduationModel?;
                                if (result != null) {
                                  contextTemp.add(
                                    UserProfileAccessEventAddGraduation(
                                      result,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<UserProfileAccessBloc,
                              UserProfileAccessState>(
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
                                                  .read<UserProfileAccessBloc>()
                                                  .add(
                                                    UserProfileAccessEventRemoveGraduation(
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
                      const Text('Selecione as especialidades'),
                      Row(children: [
                        IconButton(
                            onPressed: () async {
                              var contextTemp =
                                  context.read<UserProfileAccessBloc>();
                              ExpertiseModel? result =
                                  await Navigator.of(context)
                                          .pushNamed('/expertise/select')
                                      as ExpertiseModel?;
                              if (result != null) {
                                contextTemp.add(
                                  UserProfileAccessEventAddExpertise(
                                    result,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.search)),
                        BlocBuilder<UserProfileAccessBloc,
                            UserProfileAccessState>(
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
                                                .read<UserProfileAccessBloc>()
                                                .add(
                                                  UserProfileAccessEventRemoveExpertise(
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
                      ]),
                      const Text('Selecione os procedimentos'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp =
                                    context.read<UserProfileAccessBloc>();
                                ProcedureModel? result =
                                    await Navigator.of(context)
                                            .pushNamed('/procedure/select')
                                        as ProcedureModel?;
                                if (result != null) {
                                  contextTemp.add(
                                    UserProfileAccessEventAddProcedure(
                                      result,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<UserProfileAccessBloc,
                              UserProfileAccessState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: state.proceduresUpdated
                                    .map(
                                      (e) => Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('${e.code}'),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              context
                                                  .read<UserProfileAccessBloc>()
                                                  .add(
                                                    UserProfileAccessEventRemoveProcedure(
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

  Widget accessSelect(String name, String access) {
    return SizedBox(
      width: 170,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name),
              BlocBuilder<UserProfileAccessBloc, UserProfileAccessState>(
                builder: (context, state) {
                  return Checkbox(
                      tristate: true,
                      value: state.access.contains(access),
                      onChanged: (value) {
                        context.read<UserProfileAccessBloc>().add(
                            UserProfileAccessEventUpdateAccess(access: access));
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
