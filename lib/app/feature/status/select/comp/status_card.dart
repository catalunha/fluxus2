import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/Status_model.dart';
import '../bloc/Status_select_bloc.dart';
import '../bloc/Status_select_event.dart';
import '../bloc/Status_select_state.dart';

class StatusCard extends StatelessWidget {
  final StatusModel model;
  const StatusCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatusSelectBloc, StatusSelectState>(
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
                    .read<StatusSelectBloc>()
                    .add(StatusSelectEventUpdateSelectedValues(model));
              }
            });
      },
    );
  }
}
