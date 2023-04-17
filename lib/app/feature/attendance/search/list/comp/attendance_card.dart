import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/models/attendance_model.dart';
import '../../../../utils/app_text_title_value.dart';
import '../../../save/attendance_save_page.dart';
import '../../../view/attendance_view_page.dart';
import '../../bloc/attendance_search_bloc.dart';

class AttendanceCard extends StatelessWidget {
  final AttendanceModel model;
  const AttendanceCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/y');
    final dateFormatHM = DateFormat('dd/MM/y HH:mm');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              title: 'Descrição: ',
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
            Center(
              child: Wrap(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value:
                                BlocProvider.of<AttendanceSearchBloc>(context),
                            child: AttendanceSavePage(model: model),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AttendanceViewPage(model: model),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.assignment_ind_outlined,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
