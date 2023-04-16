import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/graduation_model.dart';
import '../bloc/graduation_select_bloc.dart';
import '../bloc/graduation_select_event.dart';
import '../bloc/graduation_select_state.dart';

class GraduationCard extends StatelessWidget {
  final GraduationModel model;
  const GraduationCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GraduationSelectBloc, GraduationSelectState>(
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
                    .read<GraduationSelectBloc>()
                    .add(GraduationSelectEventUpdateSelectedValues(model));
              }
            });
      },
    );
  }
}
