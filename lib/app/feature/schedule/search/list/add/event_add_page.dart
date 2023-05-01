import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/attendance_model.dart';
import '../../../../../core/models/event_model.dart';
import '../../../../../core/models/room_model.dart';
import '../../../../../core/models/status_model.dart';
import '../../../../../core/repositories/event_repository.dart';
import '../../../../utils/app_textformfield.dart';
import '../../bloc/schedule_search_bloc.dart';
import '../../bloc/schedule_search_event.dart';
import 'bloc/event_add_bloc.dart';
import 'bloc/event_add_event.dart';
import 'bloc/event_add_state.dart';

class EventAddPage extends StatelessWidget {
  final EventModel? model;
  const EventAddPage({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepositoryProvider(
        create: (context) => EventRepository(),
        child: BlocProvider(
          create: (context) => EventAddBloc(
            model: model,
            repository: RepositoryProvider.of<EventRepository>(context),
          ),
          child: EventAddView(model: model),
        ),
      ),
    );
  }
}

class EventAddView extends StatefulWidget {
  final EventModel? model;
  const EventAddView({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  State<EventAddView> createState() => _EventAddViewState();
}

class _EventAddViewState extends State<EventAddView> {
  final _formKey = GlobalKey<FormState>();
  final _historyTec = TextEditingController();
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now();
  bool delete = false;

  @override
  void initState() {
    super.initState();
    startFields(widget.model);

    // _historyTec.text = "";
    // _start = widget.model?.start ?? DateTime.now();
    // _end = widget.model?.end ?? DateTime.now();
  }

  void startFields(EventModel? eventModel) {
    _historyTec.text = "";
    _start = eventModel?.start ?? DateTime.now();
    _end = eventModel?.end ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.model == null ? "Criar" : "Editar"} Evento'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            context.read<EventAddBloc>().add(
                  EventAddEventFormSubmitted(
                    start: _start,
                    end: _end,
                    history: _historyTec.text,
                  ),
                );
          }
        },
      ),
      body: BlocListener<EventAddBloc, EventAddState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == EventAddStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == EventAddStateStatus.success) {
            Navigator.of(context).pop();
            if (delete) {
              context
                  .read<ScheduleSearchBloc>()
                  .add(ScheduleSearchEventRemoveFromList(state.model!));
            } else {
              context
                  .read<ScheduleSearchBloc>()
                  .add(ScheduleSearchEventUpdateList(state.model!));
            }
            Navigator.of(context).pop();
          }
          if (state.status == EventAddStateStatus.updated) {
            Navigator.of(context).pop();
            startFields(state.model);
          }
          if (state.status == EventAddStateStatus.loading) {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
        },
        child: Center(
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Divider(height: 5),
                      const Text('Inicio'),
                      SizedBox(
                        width: 300,
                        height: 100,
                        child: CupertinoDatePicker(
                          initialDateTime: _start,
                          mode: CupertinoDatePickerMode.dateAndTime,
                          use24hFormat: true,
                          onDateTimeChanged: (DateTime newDate) {
                            _start = newDate;
                          },
                        ),
                      ),
                      const Divider(height: 5),
                      const Text('Fim'),
                      SizedBox(
                        width: 300,
                        height: 100,
                        child: CupertinoDatePicker(
                          initialDateTime: _end,
                          mode: CupertinoDatePickerMode.dateAndTime,
                          use24hFormat: true,
                          onDateTimeChanged: (DateTime newDate) {
                            _end = newDate;
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text('Selecione o status'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp = context.read<EventAddBloc>();
                                List<StatusModel>? result =
                                    await Navigator.of(context).pushNamed(
                                        '/status/select',
                                        arguments: true) as List<StatusModel>?;
                                if (result != null) {
                                  contextTemp
                                      .add(EventAddEventAddStatus(result[0]));
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<EventAddBloc, EventAddState>(
                            builder: (context, state) {
                              return Text('${state.statusEvent?.name}');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Text('Selecione uma sala'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp = context.read<EventAddBloc>();
                                List<RoomModel>? result =
                                    await Navigator.of(context).pushNamed(
                                        '/room/select',
                                        arguments: true) as List<RoomModel>?;
                                if (result != null) {
                                  contextTemp
                                      .add(EventAddEventAddRoom(result[0]));
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<EventAddBloc, EventAddState>(
                            builder: (context, state) {
                              return Text('${state.room?.name}');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Text('Selecione os atendimentos'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp = context.read<EventAddBloc>();
                                List<AttendanceModel>? results =
                                    await Navigator.of(context).pushNamed(
                                            '/attendance/select',
                                            arguments: false)
                                        as List<AttendanceModel>?;
                                if (results != null) {
                                  for (var result in results) {
                                    contextTemp.add(
                                      EventAddEventAddAttendance(
                                        result,
                                      ),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.add)),
                          BlocBuilder<EventAddBloc, EventAddState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: state.attendancesUpdated
                                    .map(
                                      (e) => Row(
                                        children: [
                                          Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Id: ${e.id}'),
                                                  Text(
                                                      'Prof.: ${e.professional?.name}'),
                                                  Text(
                                                      'Proc.: ${e.procedure?.code}'),
                                                  Text(
                                                      'Pac.: ${e.patient?.name}'),
                                                  Text(
                                                      'PS: ${e.healthPlan?.code}'),
                                                  Text(
                                                      'PS Tipo: ${e.healthPlan?.healthPlanType?.name}'),
                                                ],
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              context.read<EventAddBloc>().add(
                                                    EventAddEventRemoveAttendance(
                                                      e,
                                                    ),
                                                  );
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                          ),
                          const SizedBox(width: 15)
                        ],
                      ),
                      AppTextFormField(
                        label: 'Histórico',
                        controller: _historyTec,
                      ),
                      BlocBuilder<EventAddBloc, EventAddState>(
                        builder: (context, state) {
                          return Text('${state.model?.history}');
                        },
                      ),
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
