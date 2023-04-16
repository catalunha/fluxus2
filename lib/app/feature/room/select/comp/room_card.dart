import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/room_model.dart';
import '../bloc/room_select_bloc.dart';
import '../bloc/room_select_event.dart';
import '../bloc/room_select_state.dart';

class RoomCard extends StatelessWidget {
  final RoomModel model;
  const RoomCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomSelectBloc, RoomSelectState>(
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
                    .read<RoomSelectBloc>()
                    .add(RoomSelectEventUpdateSelectedValues(model));
              }
            });
      },
    );
  }
}
