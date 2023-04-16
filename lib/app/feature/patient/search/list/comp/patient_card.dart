import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/models/patient_model.dart';
import '../../../../utils/app_text_title_value.dart';
import '../../../save/patient_save_page.dart';
import '../../../view/patient_view_page.dart';
import '../../bloc/patient_search_bloc.dart';

class PatientCard extends StatelessWidget {
  final PatientModel model;
  const PatientCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/y');

    return Card(
      child: Column(
        children: [
          AppTextTitleValue(
            title: 'Email: ',
            value: model.email,
          ),
          AppTextTitleValue(
            title: 'Nome: ',
            value: '${model.name}',
          ),
          AppTextTitleValue(
            title: 'Nome curto: ',
            value: model.nickname,
            inColumn: true,
          ),
          AppTextTitleValue(
            title: 'Telefone: ',
            value: '${model.phone}',
          ),
          AppTextTitleValue(
            title: 'CPF: ',
            value: '${model.cpf}',
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
            value: model.healthPlans?.map((e) => e.code).toList().join(', '),
            inColumn: true,
          ),
          Wrap(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<PatientSearchBloc>(context),
                        child: PatientSavePage(model: model),
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
                      builder: (_) => PatientViewPage(model: model),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.assignment_ind_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // copy(String text) async {
  //   Get.snackbar(text, 'Id copiado.',
  //       margin: const EdgeInsets.all(10), duration: const Duration(seconds: 1));
  //   await Clipboard.setData(ClipboardData(text: text));
  // }
}