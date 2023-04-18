import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/event_model.dart';
import '../bloc/event_select_bloc.dart';
import '../bloc/event_select_event.dart';
import '../bloc/event_select_state.dart';

class EventCard extends StatelessWidget {
  final EventModel model;
  const EventCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventSelectBloc, EventSelectState>(
      builder: (context, state) {
        Color? color;
        if (state.selectedValues.contains(model)) {
          color = Colors.green;
        }
        return ListTile(
            title: Text('${model.id}'),
            tileColor: color,
            onTap: () {
              if (state.isSingleValue) {
                Navigator.of(context).pop([model]);
              } else {
                context
                    .read<EventSelectBloc>()
                    .add(EventSelectEventUpdateSelectedValues(model));
              }
            });
      },
    );
  }
}
