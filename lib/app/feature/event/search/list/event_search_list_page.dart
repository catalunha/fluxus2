import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/event_model.dart';
import '../bloc/event_search_bloc.dart';
import '../bloc/event_search_event.dart';
import '../bloc/event_search_state.dart';
import 'comp/event_card.dart';

class EventSearchListPage extends StatelessWidget {
  const EventSearchListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const EventSearchListView();
  }
}

class EventSearchListView extends StatelessWidget {
  const EventSearchListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos encontrados'),
        actions: [
          IconButton(
            onPressed: () {
              List<EventModel> modelList =
                  context.read<EventSearchBloc>().state.list;
              Navigator.of(context)
                  .pushNamed('/event/print', arguments: modelList);
            },
            icon: const Icon(Icons.print),
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BlocBuilder<EventSearchBloc, EventSearchState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: state.firstPage
                        ? null
                        : () {
                            context
                                .read<EventSearchBloc>()
                                .add(EventSearchEventPreviousPage());
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
              BlocBuilder<EventSearchBloc, EventSearchState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: state.lastPage
                        ? null
                        : () {
                            context
                                .read<EventSearchBloc>()
                                .add(EventSearchEventNextPage());
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
              child: BlocBuilder<EventSearchBloc, EventSearchState>(
                builder: (context, state) {
                  var list = state.list;

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final person = list[index];
                      return EventCard(
                        model: person,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
