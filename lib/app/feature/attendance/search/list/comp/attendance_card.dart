import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/Attendance_model.dart';
import '../../../../utils/app_text_title_value.dart';
import '../../../save/Attendance_save_page.dart';
import '../../../view/Attendance_view_page.dart';
import '../../bloc/Attendance_search_bloc.dart';

class AttendanceCard extends StatelessWidget {
  final AttendanceModel model;
  const AttendanceCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
              title: 'Estado: ',
              value: model.uf,
            ),
            AppTextTitleValue(
              title: 'Cidade: ',
              value: model.city,
            ),
            AppTextTitleValue(
              title: 'Nome: ',
              value: model.name,
            ),
            Center(
              child: Wrap(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value:
                                BlocProvider.of<AttendanceSearchBloc>(context),
                            child: AttendanceSavePage(model: model),
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
                          builder: (_) => AttendanceViewPage(model: model),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.assignment_ind_outlined,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
