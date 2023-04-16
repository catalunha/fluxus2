import 'package:flutter/material.dart';

import '../../../core/models/procedure_model.dart';
import '../../utils/app_text_title_value.dart';

class ProcedureViewPage extends StatelessWidget {
  final ProcedureModel model;
  const ProcedureViewPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados deste procedimento')),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppTextTitleValue(
                //   title: 'Id: ',
                //   value: model.id,
                // ),
                AppTextTitleValue(
                  title: 'Codigo: ',
                  value: model.code,
                ),
                AppTextTitleValue(
                  title: 'Name: ',
                  value: model.name,
                ),
                AppTextTitleValue(
                  title: 'Custo: ',
                  value: model.cost?.toString(),
                ),
                AppTextTitleValue(
                  title: 'Especialidade: ',
                  value: model.expertise?.name,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
