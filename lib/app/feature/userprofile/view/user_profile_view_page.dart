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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                  title: 'Registro: ',
                  value: model.register,
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
                  title: 'Acesso: ',
                  value: model.isActive ? "LIBERADO" : "bloqueado",
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
                  title: 'Acessa como: ',
                  value: model.access.join('\n'),
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Graduações: ',
                  value:
                      model.graduations?.map((e) => e.name).toList().join(', '),
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Especialidade: ',
                  value:
                      model.expertises?.map((e) => e.name).toList().join(', '),
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Procedimentos: ',
                  value:
                      model.procedures?.map((e) => e.code).toList().join(', '),
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
