import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/graduation_model.dart';
import '../../../utils/app_text_title_value.dart';
import '../../save/graduation_save_page.dart';
import '../bloc/graduation_list_bloc.dart';

class GraduationCard extends StatelessWidget {
  final GraduationModel model;
  const GraduationCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          AppTextTitleValue(
            title: 'Id: ',
            value: model.id,
          ),
          AppTextTitleValue(
            title: 'Nome: ',
            value: model.name,
          ),
          Wrap(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<GraduationListBloc>(context),
                        child: GraduationSavePage(model: model),
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
