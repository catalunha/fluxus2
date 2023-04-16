import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/patient_model.dart';
import '../../utils/app_text_title_value.dart';

class PatientViewPage extends StatelessWidget {
  final PatientModel model;
  PatientViewPage({
    Key? key,
    required this.model,
  }) : super(key: key);
  final dateFormat = DateFormat('dd/MM/y');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados do paciente')),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextTitleValue(
                  title: 'E-mail: ',
                  value: model.email,
                ),
                AppTextTitleValue(
                  title: 'Nome curto: ',
                  value: model.nickname,
                ),
                AppTextTitleValue(
                  title: 'Nome completo: ',
                  value: model.name,
                ),
                AppTextTitleValue(
                  title: 'CPF: ',
                  value: model.cpf,
                ),
                AppTextTitleValue(
                  title: 'Telefone: ',
                  value: model.phone,
                ),
                AppTextTitleValue(
                  title: 'Endereço: ',
                  value: model.address,
                ),
                AppTextTitleValue(
                  title: 'Região: ',
                  value:
                      '${model.region?.uf}. ${model.region?.city}. ${model.region?.name}',
                ),
                AppTextTitleValue(
                  title: 'Sexo: ',
                  value: model.isFemale ?? true ? "Feminino" : "Masculino",
                ),
                AppTextTitleValue(
                  title: 'Aniversário: ',
                  value: model.birthday == null
                      ? '...'
                      : dateFormat.format(model.birthday!),
                ),
                AppTextTitleValue(
                  title: 'Familiares: ',
                  value: model.family?.map((e) => e.name).toList().join(', '),
                ),
                AppTextTitleValue(
                  title: 'Plano de Saúde: ',
                  value:
                      model.healthPlans?.map((e) => e.code).toList().join(', '),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
