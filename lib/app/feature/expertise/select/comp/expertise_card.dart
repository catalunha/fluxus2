import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/expertise_model.dart';
import '../bloc/expertise_select_bloc.dart';
import '../bloc/expertise_select_event.dart';
import '../bloc/expertise_select_state.dart';

class ExpertiseCard extends StatelessWidget {
  final ExpertiseModel model;
  const ExpertiseCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpertiseSelectBloc, ExpertiseSelectState>(
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
                    .read<ExpertiseSelectBloc>()
                    .add(ExpertiseSelectEventUpdateSelectedValues(model));
              }
            });
      },
    );
  }
}
