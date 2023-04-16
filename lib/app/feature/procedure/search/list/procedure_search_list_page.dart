import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/procedure_model.dart';
import '../bloc/procedure_search_bloc.dart';
import '../bloc/procedure_search_event.dart';
import '../bloc/procedure_search_state.dart';
import 'comp/procedure_card.dart';

class ProcedureSearchListPage extends StatelessWidget {
  const ProcedureSearchListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ProcedureSearchListView();
  }
}

class ProcedureSearchListView extends StatelessWidget {
  const ProcedureSearchListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Procedimentos encontrados'),
        actions: [
          IconButton(
            onPressed: () {
              List<ProcedureModel> modelList =
                  context.read<ProcedureSearchBloc>().state.list;
              Navigator.of(context)
                  .pushNamed('/procedure/print', arguments: modelList);
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
              BlocBuilder<ProcedureSearchBloc, ProcedureSearchState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: state.firstPage
                        ? null
                        : () {
                            context
                                .read<ProcedureSearchBloc>()
                                .add(ProcedureSearchEventPreviousPage());
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
              BlocBuilder<ProcedureSearchBloc, ProcedureSearchState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: state.lastPage
                        ? null
                        : () {
                            context
                                .read<ProcedureSearchBloc>()
                                .add(ProcedureSearchEventNextPage());
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
              child: BlocBuilder<ProcedureSearchBloc, ProcedureSearchState>(
                builder: (context, state) {
                  var list = state.list;

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return ProcedureCard(
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
    );
  }
}
