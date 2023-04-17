import 'package:flutter/material.dart';

import '../../../core/models/Attendance_model.dart';
import '../../utils/app_text_title_value.dart';

class AttendanceViewPage extends StatelessWidget {
  final AttendanceModel model;
  const AttendanceViewPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados desta região')),
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
                  title: 'UF: ',
                  value: model.uf,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Cidade: ',
                  value: model.city,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Nome: ',
                  value: model.name,
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
