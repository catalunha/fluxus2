import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/procedure_model.dart';
import '../bloc/procedure_select_bloc.dart';
import '../bloc/procedure_select_event.dart';
import '../bloc/procedure_select_state.dart';

class ProcedureCard extends StatelessWidget {
  final ProcedureModel model;
  const ProcedureCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProcedureSelectBloc, ProcedureSelectState>(
      builder: (context, state) {
        Color? color;
        if (state.selectedValues.contains(model)) {
          color = Colors.green;
        }
        return ListTile(
            title: Text('${model.code} - ${model.name}. R\$ ${model.cost}'),
            tileColor: color,
            onTap: () {
              if (state.isSingleValue) {
                Navigator.of(context).pop([model]);
              } else {
                context
                    .read<ProcedureSelectBloc>()
                    .add(ProcedureSelectEventUpdateSelectedValues(model));
              }
            });
      },
    );
  }
}
