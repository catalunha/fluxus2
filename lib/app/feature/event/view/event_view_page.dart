import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/models/event_model.dart';
import '../../../core/repositories/event_repository.dart';
import '../../utils/app_text_title_value.dart';
import 'bloc/event_view_bloc.dart';
import 'bloc/event_view_state.dart';

class EventViewPage extends StatelessWidget {
  final EventModel model;
  const EventViewPage({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepositoryProvider(
        create: (context) => EventRepository(),
        child: BlocProvider(
          create: (context) => EventViewBloc(
            model: model,
            repository: RepositoryProvider.of<EventRepository>(context),
          ),
          child: EventViewView(model: model),
        ),
      ),
    );
  }
}

class EventViewView extends StatelessWidget {
  final EventModel model;
  EventViewView({
    Key? key,
    required this.model,
  }) : super(key: key);
  final dateFormat = DateFormat('dd/MM/y HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados do evento')),
      body: BlocListener<EventViewBloc, EventViewState>(
        listener: (context, state) async {
          if (state.status == EventViewStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == EventViewStateStatus.updated) {
            Navigator.of(context).pop();
          }
          if (state.status == EventViewStateStatus.loading) {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<EventViewBloc, EventViewState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextTitleValue(
                        title: 'Id: ',
                        value: state.model.id,
                      ),
                      // AppTextTitleValue(
                      //   title: 'Atendimentos: ',
                      //   value: state.model.attendances
                      //       ?.map((e) =>
                      //           '${e.professional?.nickname} - ${e.professional?.nickname}')
                      //       .toList()
                      //       .join(', '),
                      // ),
                      const Text('Atendimentos:'),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: state.model.attendances!
                            .map(
                              (e) => Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Id: ${e.id}'),
                                      Text('Prof.: ${e.professional?.name}'),
                                      Text('Proc.: ${e.procedure?.code}'),
                                      Text('Pac.: ${e.patient?.name}'),
                                      Text('PS: ${e.healthPlan?.code}'),
                                      Text(
                                          'PS Tipo: ${e.healthPlan?.healthPlanType?.name}'),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      AppTextTitleValue(
                        title: 'Status: ',
                        value: '${state.model.status?.name}',
                      ),
                      AppTextTitleValue(
                        title: 'Sala: ',
                        value: '${state.model.room?.name}',
                      ),
                      AppTextTitleValue(
                        title: 'Inicio: ',
                        value: state.model.start == null
                            ? '...'
                            : dateFormat.format(state.model.start!),
                      ),
                      AppTextTitleValue(
                        title: 'Fim: ',
                        value: state.model.end == null
                            ? '...'
                            : dateFormat.format(state.model.end!),
                      ),
                      AppTextTitleValue(
                        title: 'Histórico: ',
                        value: state.model.history,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
