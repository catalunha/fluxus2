import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/user_profile_model.dart';
import '../../utils/app_photo_show.dart';
import '../../utils/app_text_title_value.dart';

class UserProfileViewPage extends StatelessWidget {
  final UserProfileModel model;
  UserProfileViewPage({
    Key? key,
    required this.model,
  }) : super(key: key);
  final dateFormat = DateFormat('dd/MM/y');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados desta pessoa')),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppTextTitleValue(
                  title: 'Foto:',
                  value: '',
                ),
                AppImageShow(
                  photoUrl: model.photo,
                  height: 100,
                  width: 100,
                ),
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
                  title: 'Registro: ',
                  value: model.register,
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
                  title: 'Acesso: ',
                  value: model.isActive ? "LIBERADO" : "bloqueado",
                ),
                AppTextTitleValue(
                  title: 'Aniversário: ',
                  value: model.birthday == null
                      ? '...'
                      : dateFormat.format(model.birthday!),
                ),
                AppTextTitleValue(
                  title: 'Acessa como: ',
                  value: model.access.join('\n'),
                ),
                AppTextTitleValue(
                  title: 'Cargos: ',
                  value: model.offices?.map((e) => e.name).toList().join(', '),
                ),
                AppTextTitleValue(
                  title: 'Especialidades: ',
                  value:
                      model.expertises?.map((e) => e.name).toList().join(', '),
                ),
                AppTextTitleValue(
                  title: 'Procedimentos: ',
                  value:
                      model.procedures?.map((e) => e.code).toList().join(', '),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
