import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/Status_model.dart';
import '../../../utils/app_text_title_value.dart';
import '../../save/Status_save_page.dart';
import '../bloc/Status_list_bloc.dart';

class StatusCard extends StatelessWidget {
  final StatusModel model;
  const StatusCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppTextTitleValue(
            //   title: 'Id: ',
            //   value: model.id,
            // ),
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
                            value: BlocProvider.of<StatusListBloc>(context),
                            child: StatusSavePage(model: model),
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
            ),
          ],
        ),
      ),
    );
  }
}
