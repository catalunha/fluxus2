import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/attendance_model.dart';
import '../../utils/app_text_title_value.dart';

class AttendanceViewPage extends StatelessWidget {
  final AttendanceModel model;
  const AttendanceViewPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/y');
    final dateFormatHM = DateFormat('dd/MM/y HH:mm');

    return Scaffold(
      appBar: AppBar(title: const Text('Dados deste atendimento')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextTitleValue(
                  title: 'Id: ',
                  value: model.id,
                ),
                AppTextTitleValue(
                  title: 'Profissional: ',
                  value: model.professional?.nickname,
                ),
                AppTextTitleValue(
                  title: 'Procedimento: ',
                  value: model.procedure?.code,
                ),
                AppTextTitleValue(
                  title: 'Paciente: ',
                  value: model.patient?.nickname,
                ),
                AppTextTitleValue(
                  title: 'Plano de saúde: ',
                  value: model.healthPlan?.code,
                ),
                AppTextTitleValue(
                  title: 'Tipo de Plano de saúde: ',
                  value: model.healthPlan?.healthPlanType?.name,
                ),
                AppTextTitleValue(
                  title: 'Autorização. Código: ',
                  value: model.authorizationCode,
                ),
                AppTextTitleValue(
                  title: 'Autorização. Criada em: ',
                  value: model.authorizationDateCreated == null
                      ? '...'
                      : dateFormat.format(model.authorizationDateCreated!),
                ),
                AppTextTitleValue(
                  title: 'Autorização. Limitada a: ',
                  value: model.authorizationDateLimit == null
                      ? '...'
                      : dateFormat.format(model.authorizationDateLimit!),
                ),
                AppTextTitleValue(
                  title: 'Atendida em: ',
                  value: model.attendance == null
                      ? '...'
                      : dateFormatHM.format(model.attendance!),
                ),
                AppTextTitleValue(
                  title: 'Descrição',
                  value: model.description,
                ),
                AppTextTitleValue(
                  title: 'Presença confirmada em: ',
                  value: model.confirmedPresence == null
                      ? '...'
                      : dateFormatHM.format(model.confirmedPresence!),
                ),
                AppTextTitleValue(
                  title: 'Status: ',
                  value: model.status?.name,
                ),
                AppTextTitleValue(
                  title: 'Evento: ',
                  value: model.event?.id,
                ),
                AppTextTitleValue(
                  title: 'Evolution: ',
                  value: model.evolution?.id,
                ),
                AppTextTitleValue(
                  title: 'Fatura: ',
                  value: model.invoice?.id,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
