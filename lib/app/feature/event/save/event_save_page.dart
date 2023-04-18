import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/attendance_model.dart';
import '../../../core/models/event_model.dart';
import '../../../core/models/room_model.dart';
import '../../../core/models/status_model.dart';
import '../../../core/repositories/event_repository.dart';
import '../search/bloc/event_search_bloc.dart';
import '../search/bloc/event_search_event.dart';
import 'bloc/event_save_bloc.dart';
import 'bloc/event_save_event.dart';
import 'bloc/event_save_state.dart';

class EventSavePage extends StatelessWidget {
  final EventModel? model;
  const EventSavePage({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepositoryProvider(
        create: (context) => EventRepository(),
        child: BlocProvider(
          create: (context) => EventSaveBloc(
            model: model,
            repository: RepositoryProvider.of<EventRepository>(context),
          ),
          child: EventSaveView(model: model),
        ),
      ),
    );
  }
}

class EventSaveView extends StatefulWidget {
  final EventModel? model;
  const EventSaveView({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  State<EventSaveView> createState() => _EventSaveViewState();
}

class _EventSaveViewState extends State<EventSaveView> {
  final _formKey = GlobalKey<FormState>();
  final _historyTec = TextEditingController();
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now();
  bool delete = false;

  @override
  void initState() {
    super.initState();
    _historyTec.text = "";
    _start = widget.model?.start ?? DateTime.now();
    _end = widget.model?.end ?? DateTime.now();
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
            context.read<EventSaveBloc>().add(
                  EventSaveEventFormSubmitted(
                    start: _start,
                    end: _end,
                    history: _historyTec.text,
                  ),
                );
          }
        },
      ),
      body: BlocListener<EventSaveBloc, EventSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == EventSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == EventSaveStateStatus.success) {
            Navigator.of(context).pop();
            if (widget.model != null) {
              if (delete) {
                context
                    .read<EventSearchBloc>()
                    .add(EventSearchEventRemoveFromList(state.model!));
              } else {
                context
                    .read<EventSearchBloc>()
                    .add(EventSearchEventUpdateList(state.model!));
              }
            }
            Navigator.of(context).pop();
          }

          if (state.status == EventSaveStateStatus.loading) {
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
                                var contextTemp = context.read<EventSaveBloc>();
                                List<StatusModel>? result =
                                    await Navigator.of(context).pushNamed(
                                        '/status/select',
                                        arguments: true) as List<StatusModel>?;
                                if (result != null) {
                                  contextTemp
                                      .add(EventSaveEventAddStatus(result[0]));
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<EventSaveBloc, EventSaveState>(
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
                                var contextTemp = context.read<EventSaveBloc>();
                                List<RoomModel>? result =
                                    await Navigator.of(context).pushNamed(
                                        '/room/select',
                                        arguments: true) as List<RoomModel>?;
                                if (result != null) {
                                  contextTemp
                                      .add(EventSaveEventAddRoom(result[0]));
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<EventSaveBloc, EventSaveState>(
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
                                var contextTemp = context.read<EventSaveBloc>();
                                List<AttendanceModel>? results =
                                    await Navigator.of(context).pushNamed(
                                            '/attendance/select',
                                            arguments: false)
                                        as List<AttendanceModel>?;
                                if (results != null) {
                                  for (var result in results) {
                                    contextTemp.add(
                                      EventSaveEventAddAttendance(
                                        result,
                                      ),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.add)),
                          BlocBuilder<EventSaveBloc, EventSaveState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: state.attendancesUpdated
                                    .map(
                                      (e) => Row(
                                        children: [
                                          Text('${e.id}'),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              context.read<EventSaveBloc>().add(
                                                    EventSaveEventRemoveAttendance(
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
