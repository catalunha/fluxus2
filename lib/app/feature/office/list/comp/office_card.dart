import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/office_model.dart';
import '../../../utils/app_text_title_value.dart';
import '../../save/office_save_page.dart';
import '../bloc/office_list_bloc.dart';

class OfficeCard extends StatelessWidget {
  final OfficeModel model;
  const OfficeCard({Key? key, required this.model}) : super(key: key);

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
                            value: BlocProvider.of<OfficeListBloc>(context),
                            child: OfficeSavePage(model: model),
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
