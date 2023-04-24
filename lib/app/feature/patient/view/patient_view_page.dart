import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/models/patient_model.dart';
import '../../../core/repositories/patient_repository.dart';
import '../../utils/app_text_title_value.dart';
import 'bloc/patient_view_bloc.dart';
import 'bloc/patient_view_state.dart';

class PatientViewPage extends StatelessWidget {
  final PatientModel model;
  const PatientViewPage({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepositoryProvider(
        create: (context) => PatientRepository(),
        child: BlocProvider(
          create: (context) => PatientViewBloc(
            model: model,
            repository: RepositoryProvider.of<PatientRepository>(context),
          ),
          child: PatientViewView(model: model),
        ),
      ),
    );
  }
}

class PatientViewView extends StatelessWidget {
  final PatientModel model;
  PatientViewView({
    Key? key,
    required this.model,
  }) : super(key: key);
  final dateFormat = DateFormat('dd/MM/y');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados do paciente')),
      body: BlocListener<PatientViewBloc, PatientViewState>(
        listener: (context, state) async {
          if (state.status == PatientViewStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == PatientViewStateStatus.updated) {
            Navigator.of(context).pop();
          }
          if (state.status == PatientViewStateStatus.loading) {
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
              child: BlocBuilder<PatientViewBloc, PatientViewState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        title: 'Aniversário: ',
                        value: state.model.birthday == null
                            ? '...'
                            : dateFormat.format(state.model.birthday!),
                      ),
                      AppTextTitleValue(
                        title: 'Familiares.name: ',
                        value: state.model.family
                            ?.map((e) => e.name)
                            .toList()
                            .join(', '),
                      ),
                      AppTextTitleValue(
                        title: 'Familiares.nickname: ',
                        value: state.model.family
                            ?.map((e) => e.nickname)
                            .toList()
                            .join(', '),
                      ),
                      AppTextTitleValue(
                        title: 'Plano de Saúde: ',
                        value: state.model.healthPlans
                            ?.map((e) => e.code)
                            .toList()
                            .join(', '),
                      ),
                      AppTextTitleValue(
                        title: 'Plano de Saúde id: ',
                        value: state.model.healthPlans
                            ?.map((e) => e.id)
                            .toList()
                            .join(', '),
                      ),
                      AppTextTitleValue(
                        title: 'Plano de Saúde code: ',
                        value: state.model.healthPlans
                            ?.map((e) => e.code)
                            .toList()
                            .join(', '),
                      ),
                      AppTextTitleValue(
                        title: 'Plano de Saúde desc: ',
                        value: state.model.healthPlans
                            ?.map((e) => e.description)
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
