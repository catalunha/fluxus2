import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/event_model.dart';
import '../../../../../core/repositories/attendance_repository.dart';
import '../../bloc/schedule_search_bloc.dart';
import '../../bloc/schedule_search_event.dart';
import 'bloc/schedule_confirm_presence_bloc.dart';
import 'bloc/schedule_confirm_presence_event.dart';
import 'bloc/schedule_confirm_presence_state.dart';

class ScheduleConfirmAttendancePage extends StatelessWidget {
  final EventModel event;

  const ScheduleConfirmAttendancePage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AttendanceRepository(),
      child: BlocProvider(
        create: (context) => ScheduleConfirmPresenceBloc(
          event: event,
          repository: RepositoryProvider.of<AttendanceRepository>(context),
        ),
        child: const ScheduleConfirmAttendanceView(),
      ),
    );
  }
}

class ScheduleConfirmAttendanceView extends StatelessWidget {
  const ScheduleConfirmAttendanceView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocListener<ScheduleConfirmPresenceBloc,
          ScheduleConfirmPresenceState>(
        listener: (_, state) async {
          if (state.status == ScheduleConfirmPresenceStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == ScheduleConfirmPresenceStateStatus.success) {
            Navigator.of(context).pop();
            context.read<ScheduleSearchBloc>().add(
                ScheduleSearchEventUpdateAttendances(
                    state.event, state.modelsConfirmThese));
            Navigator.of(context).pop();
          }

          if (state.status == ScheduleConfirmPresenceStateStatus.loading) {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<ScheduleConfirmPresenceBloc,
                    ScheduleConfirmPresenceState>(
                  builder: (context, state) {
                    final List<Widget> widgetsConfirmPresence = [];
                    for (var model in state.modelsAlreadyConfirmed) {
                      widgetsConfirmPresence.add(Text(
                          '${model.id} ${model.patient?.nickname} (${model.professional?.nickname})'));
                    }

                    for (var model in state.modelsUnconfirmed) {
                      widgetsConfirmPresence.add(
                        CheckboxListTile(
                          tristate: false,
                          title: Text(
                              '${model.id} ${model.patient?.nickname} (${model.professional?.nickname})'),
                          onChanged: (value) {
                            if (value != null && value == true) {
                              context.read<ScheduleConfirmPresenceBloc>().add(
                                  ScheduleConfirmPresenceEventAddConfirm(
                                      model));
                            } else if (value != null && value == false) {
                              context.read<ScheduleConfirmPresenceBloc>().add(
                                  ScheduleConfirmPresenceEventRemoveConfirm(
                                      model));
                            }
                          },
                          value: state.modelsConfirmThese.contains(model),
                        ),
                      );
                    }
                    return Column(children: widgetsConfirmPresence);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 50),
                    TextButton(
                      onPressed: () async {
                        context
                            .read<ScheduleConfirmPresenceBloc>()
                            .add(ScheduleConfirmPresenceEventUpdate());
                      },
                      child: const Text('Atualizar'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
