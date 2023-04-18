import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/models/event_model.dart';
import '../../../../utils/app_text_title_value.dart';

class ScheduleCard extends StatelessWidget {
  final EventModel model;
  const ScheduleCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/y HH:mm');

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
              title: 'Atendimentos: ',
              value: model.attendances?.map((e) => e.id).toList().join(', '),
            ),
            AppTextTitleValue(
              title: 'Status: ',
              value: '${model.status?.name}',
            ),
            AppTextTitleValue(
              title: 'Sala: ',
              value: '${model.room?.name}',
            ),
            AppTextTitleValue(
              title: 'Inicio: ',
              value:
                  model.start == null ? '...' : dateFormat.format(model.start!),
            ),
            AppTextTitleValue(
              title: 'Fim: ',
              value: model.end == null ? '...' : dateFormat.format(model.end!),
            ),
            AppTextTitleValue(
              title: 'Histórico: ',
              value: '\n${model.history}',
              // inColumn: true,
            ),
          ],
        ),
      ),
    );
  }

  // copy(String text) async {
  //   Get.snackbar(text, 'Id copiado.',
  //       margin: const EdgeInsets.all(10), duration: const Duration(seconds: 1));
  //   await Clipboard.setData(ClipboardData(text: text));
  // }
}
