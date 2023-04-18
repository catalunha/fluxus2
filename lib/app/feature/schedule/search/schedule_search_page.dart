import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/room_model.dart';
import '../../../core/models/status_model.dart';
import '../../../core/repositories/event_repository.dart';
import '../../utils/app_icon.dart';
import 'bloc/schedule_search_bloc.dart';
import 'bloc/schedule_search_event.dart';
import 'bloc/schedule_search_state.dart';
import 'list/schedule_search_list_page.dart';

class ScheduleSearchPage extends StatelessWidget {
  const ScheduleSearchPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => EventRepository(),
      child: BlocProvider(
        create: (context) => ScheduleSearchBloc(
            repository: RepositoryProvider.of<EventRepository>(context)),
        child: const ScheduleSearchView(),
      ),
    );
  }
}

class ScheduleSearchView extends StatefulWidget {
  const ScheduleSearchView({Key? key}) : super(key: key);

  @override
  State<ScheduleSearchView> createState() => _SearchPageState();
}

class _SearchPageState extends State<ScheduleSearchView> {
  final _formKey = GlobalKey<FormState>();
  bool? selectedRoom;
  bool? selectedStatus;
  bool? selectedStartEnd;
  DateTime? start;
  DateTime? end;
  RoomModel? equalsRoom;
  StatusModel? equalsStatus;
  @override
  void initState() {
    super.initState();
    start = DateTime.now();
    end = DateTime.now().add(const Duration(days: 7));
    selectedRoom = false;
    selectedStatus = false;
    selectedStartEnd = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Montando agenda'),
      ),
      body: BlocListener<ScheduleSearchBloc, ScheduleSearchState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          //print('++++++++++++++++ search -------------------');

          if (state.status == ScheduleSearchStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == ScheduleSearchStateStatus.success) {
            //print('success');
            Navigator.of(context).pop();
          }
          if (state.status == ScheduleSearchStateStatus.loading) {
            //print('loading');

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
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                      child: Column(children: [
                        const Text('Inicio'),
                        SizedBox(
                          width: 300,
                          height: 100,
                          child: CupertinoDatePicker(
                            initialDateTime: start,
                            mode: CupertinoDatePickerMode.date,
                            onDateTimeChanged: (DateTime newDate) {
                              start = newDate;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Fim'),
                        SizedBox(
                          width: 300,
                          height: 100,
                          child: CupertinoDatePicker(
                            initialDateTime: end,
                            mode: CupertinoDatePickerMode.date,
                            onDateTimeChanged: (DateTime newDate) {
                              end = newDate;
                            },
                          ),
                        ),
                      ]),
                    ),
                    Card(
                      child: Column(children: [
                        const Text('Selecione um Status'),
                        Row(
                          children: [
                            Checkbox(
                              value: selectedStatus,
                              onChanged: (value) {
                                setState(() {
                                  selectedStatus = value!;
                                });
                              },
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      List<StatusModel>? result =
                                          await Navigator.of(context).pushNamed(
                                                  '/status/select',
                                                  arguments: true)
                                              as List<StatusModel>?;
                                      if (result != null) {
                                        setState(() {
                                          equalsStatus = result[0];
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.search),
                                  ),
                                  Text('${equalsStatus?.name}')
                                ],
                              ),
                            ),
                          ],
                        )
                      ]),
                    ),
                    Card(
                      child: Column(children: [
                        const Text('Selecione uma Sala'),
                        Row(
                          children: [
                            Checkbox(
                              value: selectedRoom,
                              onChanged: (value) {
                                setState(() {
                                  selectedRoom = value!;
                                });
                              },
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      List<RoomModel>? result =
                                          await Navigator.of(context).pushNamed(
                                                  '/room/select',
                                                  arguments: true)
                                              as List<RoomModel>?;
                                      if (result != null) {
                                        setState(() {
                                          equalsRoom = result[0];
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.search),
                                  ),
                                  Text('${equalsRoom?.name}')
                                ],
                              ),
                            ),
                          ],
                        )
                      ]),
                    ),
                    BlocBuilder<ScheduleSearchBloc, ScheduleSearchState>(
                      buildWhen: (current, next) {
                        print('current: ${current.list.length}');
                        print('current: ${current.start}');
                        print('current: ${current.end}');
                        print('next: ${next.list.length}');
                        print('next: ${next.start}');
                        print('next: ${next.end}');
                        return true;
                      },
                      builder: (context, state) {
                        print('=======> builder teste');
                        return const Text('Teste');
                      },
                    ),
                    const SizedBox(height: 70)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Executar busca',
        child: const Icon(AppIconData.search),
        onPressed: () async {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            context.read<ScheduleSearchBloc>().add(
                  ScheduleSearchEventFormSubmitted(
                    selectedRoom: selectedRoom!,
                    selectedStatus: selectedStatus!,
                    selectedStartEnd: selectedStartEnd!,
                    equalsRoom: equalsRoom,
                    equalsStatus: equalsStatus,
                    start: start,
                    end: end,
                  ),
                );

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<ScheduleSearchBloc>(context),
                  child: const ScheduleSearchListPage(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
