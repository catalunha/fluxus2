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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextTitleValue(
                  title: 'E-mail: ',
                  value: model.email,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Nome curto: ',
                  value: model.nickname,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Nome completo: ',
                  value: model.name,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'CPF: ',
                  value: model.cpf,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Telefone: ',
                  value: model.phone,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Endereço: ',
                  value: model.address,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Região: ',
                  value:
                      '${model.region?.uf}. ${model.region?.city}. ${model.region?.name}',
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Sexo: ',
                  value: model.isFemale ?? true ? "Feminino" : "Masculino",
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Aniversário: ',
                  value: model.birthday == null
                      ? '...'
                      : dateFormat.format(model.birthday!),
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Familiares: ',
                  value: model.family?.map((e) => e.name).toList().join(', '),
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Plano de Saúde: ',
                  value:
                      model.healthPlans?.map((e) => e.code).toList().join(', '),
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
