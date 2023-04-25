import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/attendance_model.dart';
import '../bloc/attendance_select_bloc.dart';
import '../bloc/attendance_select_event.dart';
import '../bloc/attendance_select_state.dart';

class AttendanceCard extends StatelessWidget {
  final AttendanceModel model;
  const AttendanceCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceSelectBloc, AttendanceSelectState>(
      builder: (context, state) {
        Color? color;
        if (state.selectedValues.contains(model)) {
          color = Colors.black;
        }
        return InkWell(
          child: Card(
            color: color,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Id: ${model.id}'),
                  Text('Prof.: ${model.professional?.name}'),
                  Text('Proc.: ${model.procedure?.code}'),
                  Text('Pac.: ${model.patient?.name}'),
                  Text('PS: ${model.healthPlan?.code}'),
                  Text('PS Tipo: ${model.healthPlan?.healthPlanType?.name}'),
                ],
              ),
            ),
          ),
          onTap: () {
            if (state.isSingleValue) {
              Navigator.of(context).pop([model]);
            } else {
              context
                  .read<AttendanceSelectBloc>()
                  .add(AttendanceSelectEventUpdateSelectedValues(model));
            }
          },
        );
        // return ListTile(
        //   title: Text('${model.id}'),
        //   tileColor: color,
        //   onTap: () {
        //     if (state.isSingleValue) {
        //       Navigator.of(context).pop([model]);
        //     } else {
        //       context
        //           .read<AttendanceSelectBloc>()
        //           .add(AttendanceSelectEventUpdateSelectedValues(model));
        //     }
        //   },
        // );
      },
    );
  }
}
