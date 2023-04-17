import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/office_model.dart';
import '../bloc/office_select_bloc.dart';
import '../bloc/office_select_event.dart';
import '../bloc/office_select_state.dart';

class OfficeCard extends StatelessWidget {
  final OfficeModel model;
  const OfficeCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfficeSelectBloc, OfficeSelectState>(
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
                    .read<OfficeSelectBloc>()
                    .add(OfficeSelectEventUpdateSelectedValues(model));
              }
            });
      },
    );
  }
}
