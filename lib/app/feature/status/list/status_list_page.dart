import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/status_model.dart';
import '../../../core/repositories/status_repository.dart';
import '../save/status_save_page.dart';
import 'bloc/status_list_bloc.dart';
import 'bloc/status_list_event.dart';
import 'bloc/status_list_state.dart';
import 'comp/status_card.dart';

class StatusListPage extends StatelessWidget {
  const StatusListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => StatusRepository(),
      child: BlocProvider(
        create: (context) => StatusListBloc(
            repository: RepositoryProvider.of<StatusRepository>(context)),
        child: const StatusListView(),
      ),
    );
  }
}

class StatusListView extends StatelessWidget {
  const StatusListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status encontrados'),
        actions: [
          IconButton(
            onPressed: () {
              List<StatusModel> modelList =
                  context.read<StatusListBloc>().state.list;
              Navigator.of(context)
                  .pushNamed('/status/print', arguments: modelList);
            },
            icon: const Icon(Icons.print),
          )
        ],
      ),
      body: BlocListener<StatusListBloc, StatusListState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == StatusListStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == StatusListStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == StatusListStateStatus.loading) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BlocBuilder<StatusListBloc, StatusListState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.firstPage
                          ? null
                          : () {
                              context
                                  .read<StatusListBloc>()
                                  .add(StatusListEventPreviousPage());
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
                BlocBuilder<StatusListBloc, StatusListState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.lastPage
                          ? null
                          : () {
                              context
                                  .read<StatusListBloc>()
                                  .add(StatusListEventNextPage());
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
                child: BlocBuilder<StatusListBloc, StatusListState>(
                  builder: (context, state) {
                    var list = state.list;

                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return StatusCard(
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
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<StatusListBloc>(context),
                  child: const StatusSavePage(model: null),
                ),
              ),
            );
          },
          child: const Icon(Icons.add)),
    );
  }
}
