import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/healthplantype_model.dart';
import '../../../core/repositories/healthplantype_repository.dart';
import '../save/healthplantype_save_page.dart';
import 'bloc/healthplantype_list_bloc.dart';
import 'bloc/healthplantype_list_event.dart';
import 'bloc/healthplantype_list_state.dart';
import 'comp/healthplantype_card.dart';

class HealthPlanTypeListPage extends StatelessWidget {
  const HealthPlanTypeListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => HealthPlanTypeRepository(),
      child: BlocProvider(
        create: (context) => HealthPlanTypeListBloc(
            repository:
                RepositoryProvider.of<HealthPlanTypeRepository>(context)),
        child: const HealthPlanTypeListView(),
      ),
    );
  }
}

class HealthPlanTypeListView extends StatelessWidget {
  const HealthPlanTypeListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipos de Planos encontrados'),
        actions: [
          IconButton(
            onPressed: () {
              List<HealthPlanTypeModel> modelList =
                  context.read<HealthPlanTypeListBloc>().state.list;
              Navigator.of(context)
                  .pushNamed('/healthplantype/print', arguments: modelList);
            },
            icon: const Icon(Icons.print),
          )
        ],
      ),
      body: BlocListener<HealthPlanTypeListBloc, HealthPlanTypeListState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == HealthPlanTypeListStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == HealthPlanTypeListStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == HealthPlanTypeListStateStatus.loading) {
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
                BlocBuilder<HealthPlanTypeListBloc, HealthPlanTypeListState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.firstPage
                          ? null
                          : () {
                              context
                                  .read<HealthPlanTypeListBloc>()
                                  .add(HealthPlanTypeListEventPreviousPage());
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
                BlocBuilder<HealthPlanTypeListBloc, HealthPlanTypeListState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.lastPage
                          ? null
                          : () {
                              context
                                  .read<HealthPlanTypeListBloc>()
                                  .add(HealthPlanTypeListEventNextPage());
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
                child: BlocBuilder<HealthPlanTypeListBloc,
                    HealthPlanTypeListState>(
                  builder: (context, state) {
                    var list = state.list;

                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return HealthPlanTypeCard(
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
                  value: BlocProvider.of<HealthPlanTypeListBloc>(context),
                  child: const HealthPlanTypeSavePage(model: null),
                ),
              ),
            );
          },
          child: const Icon(Icons.add)),
    );
  }
}
