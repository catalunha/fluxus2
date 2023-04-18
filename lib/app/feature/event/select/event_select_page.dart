import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repositories/event_repository.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/event_select_bloc.dart';
import 'bloc/event_select_event.dart';
import 'bloc/event_select_state.dart';
import 'comp/event_card.dart';

class EventSelectPage extends StatelessWidget {
  final bool isSingleValue;

  const EventSelectPage({
    Key? key,
    required this.isSingleValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => EventRepository(),
      child: BlocProvider(
        create: (context) {
          return EventSelectBloc(
            repository: RepositoryProvider.of<EventRepository>(context),
            isSingleValue: isSingleValue,
          );
        },
        child: const EventSelectView(),
      ),
    );
  }
}

class EventSelectView extends StatefulWidget {
  const EventSelectView({Key? key}) : super(key: key);

  @override
  State<EventSelectView> createState() => _EventSelectViewState();
}

class _EventSelectViewState extends State<EventSelectView> {
  final _nameTEC = TextEditingController();

  @override
  void initState() {
    _nameTEC.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione um procedimento'),
      ),
      body: BlocListener<EventSelectBloc, EventSelectState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == EventSelectStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == EventSelectStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == EventSelectStateStatus.loading) {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
        },
        child: Column(
          children: [
            Form(
              child: Row(
                children: [
                  Expanded(
                    child: AppTextFormField(
                      label: 'Pesquisar por Nome',
                      controller: _nameTEC,
                      onChange: (value) {
                        context
                            .read<EventSelectBloc>()
                            .add(EventSelectEventFormSubmitted(value));
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context
                          .read<EventSelectBloc>()
                          .add(EventSelectEventFormSubmitted(_nameTEC.text));
                    },
                    icon: const Icon(Icons.youtube_searched_for_sharp),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BlocBuilder<EventSelectBloc, EventSelectState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.firstPage
                          ? null
                          : () {
                              context
                                  .read<EventSelectBloc>()
                                  .add(EventSelectEventPreviousPage());
                            },
                      child: Card(
                        color: state.firstPage ? Colors.black : Colors.black45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: state.firstPage
                                ? const Text('Primeira página')
                                : const Text('Página anterior'),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                BlocBuilder<EventSelectBloc, EventSelectState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.lastPage
                          ? null
                          : () {
                              context
                                  .read<EventSelectBloc>()
                                  .add(EventSelectEventNextPage());
                            },
                      child: Card(
                        color: state.lastPage ? Colors.black : Colors.black45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: state.lastPage
                                ? const Text('Última página')
                                : const Text('Próxima página'),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: BlocBuilder<EventSelectBloc, EventSelectState>(
                  builder: (context, state) {
                    var list = state.listFiltered;
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return EventCard(
                          model: item,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<EventSelectBloc, EventSelectState>(
        builder: (context, state) {
          return Visibility(
            visible: !state.isSingleValue,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop(state.selectedValues);
              },
              child: const Icon(Icons.send),
            ),
          );
        },
      ),
    );
  }
}
