import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/event_model.dart';
import '../../utils/app_text_title_value.dart';

class EventViewPage extends StatelessWidget {
  final EventModel model;
  EventViewPage({
    Key? key,
    required this.model,
  }) : super(key: key);
  final dateFormat = DateFormat('dd/MM/y HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados do evento')),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
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
                  value:
                      model.attendances?.map((e) => e.id).toList().join(', '),
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
                  value: model.start == null
                      ? '...'
                      : dateFormat.format(model.start!),
                ),
                AppTextTitleValue(
                  title: 'Fim: ',
                  value:
                      model.end == null ? '...' : dateFormat.format(model.end!),
                ),
                AppTextTitleValue(
                  title: 'Histórico: ',
                  value: model.history,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
