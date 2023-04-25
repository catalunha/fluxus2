import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/models/attendance_model.dart';
import '../../../core/repositories/attendance_repository.dart';
import '../../utils/app_text_title_value.dart';
import 'bloc/attendance_view_bloc.dart';
import 'bloc/attendance_view_state.dart';

class AttendanceViewPage extends StatelessWidget {
  final AttendanceModel model;
  const AttendanceViewPage({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepositoryProvider(
        create: (context) => AttendanceRepository(),
        child: BlocProvider(
          create: (context) => AttendanceViewBloc(
            model: model,
            repository: RepositoryProvider.of<AttendanceRepository>(context),
          ),
          child: AttendanceViewView(model: model),
        ),
      ),
    );
  }
}

class AttendanceViewView extends StatelessWidget {
  final AttendanceModel model;
  const AttendanceViewView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/y');
    final dateFormatHM = DateFormat('dd/MM/y HH:mm');

    return Scaffold(
      appBar: AppBar(title: const Text('Dados deste atendimento')),
      body: BlocListener<AttendanceViewBloc, AttendanceViewState>(
        listener: (context, state) async {
          if (state.status == AttendanceViewStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == AttendanceViewStateStatus.updated) {
            Navigator.of(context).pop();
          }
          if (state.status == AttendanceViewStateStatus.loading) {
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
              child: BlocBuilder<AttendanceViewBloc, AttendanceViewState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextTitleValue(
                        title: 'Id: ',
                        value: state.model.id,
                      ),
                      AppTextTitleValue(
                        title: 'Profissional: ',
                        value: state.model.professional?.nickname,
                      ),
                      AppTextTitleValue(
                        title: 'Procedimento: ',
                        value: state.model.procedure?.code,
                      ),
                      AppTextTitleValue(
                        title: 'Paciente: ',
                        value: state.model.patient?.nickname,
                      ),
                      AppTextTitleValue(
                        title: 'Plano de saúde: ',
                        value: state.model.healthPlan?.code,
                      ),
                      AppTextTitleValue(
                        title: 'Tipo de Plano de saúde: ',
                        value: state.model.healthPlan?.healthPlanType?.name,
                      ),
                      AppTextTitleValue(
                        title: 'Autorização. Código: ',
                        value: state.model.authorizationCode,
                      ),
                      AppTextTitleValue(
                        title: 'Autorização. Criada em: ',
                        value: state.model.authorizationDateCreated == null
                            ? '...'
                            : dateFormat
                                .format(state.model.authorizationDateCreated!),
                      ),
                      AppTextTitleValue(
                        title: 'Autorização. Limitada a: ',
                        value: state.model.authorizationDateLimit == null
                            ? '...'
                            : dateFormat
                                .format(state.model.authorizationDateLimit!),
                      ),
                      AppTextTitleValue(
                        title: 'Atendida em: ',
                        value: state.model.attendance == null
                            ? '...'
                            : dateFormatHM.format(state.model.attendance!),
                      ),
                      AppTextTitleValue(
                        title: 'Descrição',
                        value: state.model.description,
                      ),
                      AppTextTitleValue(
                        title: 'Presença confirmada em: ',
                        value: state.model.confirmedPresence == null
                            ? '...'
                            : dateFormatHM
                                .format(state.model.confirmedPresence!),
                      ),
                      AppTextTitleValue(
                        title: 'Status: ',
                        value: state.model.status?.name,
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
