import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repositories/expertise_repository.dart';
import 'bloc/expertise_list_bloc.dart';
import 'bloc/expertise_list_event.dart';
import 'bloc/expertise_list_state.dart';
import 'comp/expertise_card.dart';

class ExpertiseListPage extends StatelessWidget {
  const ExpertiseListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ExpertiseRepository(),
      child: BlocProvider(
        create: (context) => ExpertiseListBloc(
            repository: RepositoryProvider.of<ExpertiseRepository>(context)),
        child: const ExpertiseListView(),
      ),
    );
  }
}

class ExpertiseListView extends StatelessWidget {
  const ExpertiseListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Especialidades encontradas'),
      ),
      body: BlocListener<ExpertiseListBloc, ExpertiseListState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == ExpertiseListStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == ExpertiseListStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == ExpertiseListStateStatus.loading) {
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
                BlocBuilder<ExpertiseListBloc, ExpertiseListState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.firstPage
                          ? null
                          : () {
                              context
                                  .read<ExpertiseListBloc>()
                                  .add(ExpertiseListEventPreviousPage());
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
                BlocBuilder<ExpertiseListBloc, ExpertiseListState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.lastPage
                          ? null
                          : () {
                              context
                                  .read<ExpertiseListBloc>()
                                  .add(ExpertiseListEventNextPage());
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
                child: BlocBuilder<ExpertiseListBloc, ExpertiseListState>(
                  builder: (context, state) {
                    var list = state.list;

                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return ExpertiseCard(
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
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (_) => BlocProvider.value(
      //             value: BlocProvider.of<ExpertiseListBloc>(context),
      //             child: const ExpertiseSavePage(model: null),
      //           ),
      //         ),
      //       );
      //     },
      //     child: const Icon(Icons.add)),
    );
  }
}
