import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/patient_model.dart';
import '../bloc/patient_select_bloc.dart';
import '../bloc/patient_select_event.dart';
import '../bloc/patient_select_state.dart';

class PatientCard extends StatelessWidget {
  final PatientModel model;
  const PatientCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientSelectBloc, PatientSelectState>(
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
                    .read<PatientSelectBloc>()
                    .add(PatientSelectEventUpdateSelectedValues(model));
              }
            });
      },
    );
  }
}
