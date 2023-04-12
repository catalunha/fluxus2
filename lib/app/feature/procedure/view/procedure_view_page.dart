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
                  title: 'Codigo: ',
                  value: model.code,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Name: ',
                  value: model.name,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Custo: ',
                  value: model.cost?.toString(),
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Especialidade: ',
                  value: model.expertise?.name,
                  inColumn: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
