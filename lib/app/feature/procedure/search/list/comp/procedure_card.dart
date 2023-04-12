import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/models/procedure_model.dart';
import '../../../../utils/app_text_title_value.dart';
import '../../../save/procedure_save_page.dart';
import '../../../view/procedure_view_page.dart';
import '../../bloc/procedure_search_bloc.dart';

class ProcedureCard extends StatelessWidget {
  final ProcedureModel model;
  const ProcedureCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/y');

    return Card(
      child: Column(
        children: [
          AppTextTitleValue(
            title: 'Id: ',
            value: model.id,
          ),
          AppTextTitleValue(
            title: 'Codigo: ',
            value: model.code,
          ),
          AppTextTitleValue(
            title: 'Nome: ',
            value: model.name,
          ),
          AppTextTitleValue(
            title: 'Custo: ',
            value: model.cost?.toString(),
          ),
          AppTextTitleValue(
            title: 'Especialidade: ',
            value: model.expertise?.name,
            inColumn: true,
          ),
          Wrap(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<ProcedureSearchBloc>(context),
                        child: ProcedureSavePage(model: model),
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
                      builder: (_) => ProcedureViewPage(model: model),
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
}
