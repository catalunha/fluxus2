import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/healthplantype_model.dart';
import '../bloc/healthplantype_select_bloc.dart';
import '../bloc/healthplantype_select_event.dart';
import '../bloc/healthplantype_select_state.dart';

class HealthPlanTypeCard extends StatelessWidget {
  final HealthPlanTypeModel model;
  const HealthPlanTypeCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthPlanTypeSelectBloc, HealthPlanTypeSelectState>(
      builder: (context, state) {
        Color? color;
        if (state.selectedValues.contains(model)) {
          color = Colors.green;
        }
        return ListTile(
            title: Text('${model.name}'),
            tileColor: color,
            onTap: () {
              if (state.isSingleValue) {
                Navigator.of(context).pop([model]);
              } else {
                context
                    .read<HealthPlanTypeSelectBloc>()
                    .add(HealthPlanTypeSelectEventUpdateSelectedValues(model));
              }
            });
      },
    );
  }
}
