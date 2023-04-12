import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/user_profile_model.dart';
import '../../utils/app_photo_show.dart';
import '../../utils/app_text_title_value.dart';

class UserProfileViewPage extends StatelessWidget {
  final UserProfileModel userProfileModel;
  UserProfileViewPage({
    Key? key,
    required this.userProfileModel,
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
                  photoUrl: userProfileModel.photo,
                  height: 100,
                  width: 100,
                ),
                AppTextTitleValue(
                  title: 'E-mail: ',
                  value: userProfileModel.email,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Nome completo: ',
                  value: userProfileModel.name,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'CPF: ',
                  value: userProfileModel.cpf,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Telefone: ',
                  value: userProfileModel.phone,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Acesso: ',
                  value: userProfileModel.isActive ? "LIBERADO" : "bloqueado",
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Acessa como: ',
                  value: userProfileModel.access?.join('\n'),
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
