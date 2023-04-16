import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/patient_model.dart';
import '../bloc/patient_search_bloc.dart';
import '../bloc/patient_search_event.dart';
import '../bloc/patient_search_state.dart';
import 'comp/patient_card.dart';

class PatientSearchListPage extends StatelessWidget {
  const PatientSearchListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PatientSearchListView();
  }
}

/*
class PatientSearchListPage extends StatelessWidget {
  const PatientSearchListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: BlocProvider.of<PatientSearchBloc>(context),
        child: const PatientSearchListView(),
      ),
    );
    // return Scaffold(
    //   body: RepositoryProvider.value(
    //     value: (_) => RepositoryProvider.of<PatientRepository>(context),
    //     child: BlocProvider.value(
    //       value: BlocProvider.of<PatientSearchBloc>(context),
    //       child: const PatientSearchListView(),
    //     ),
    //   ),
    // );
  }
}
*/
class PatientSearchListView extends StatelessWidget {
  const PatientSearchListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes encontrados'),
        actions: [
          IconButton(
            onPressed: () {
              List<PatientModel> modelList =
                  context.read<PatientSearchBloc>().state.list;
              Navigator.of(context)
                  .pushNamed('/userProfile/print', arguments: modelList);
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
              BlocBuilder<PatientSearchBloc, PatientSearchState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: state.firstPage
                        ? null
                        : () {
                            context
                                .read<PatientSearchBloc>()
                                .add(PatientSearchEventPreviousPage());
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
              BlocBuilder<PatientSearchBloc, PatientSearchState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: state.lastPage
                        ? null
                        : () {
                            context
                                .read<PatientSearchBloc>()
                                .add(PatientSearchEventNextPage());
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
              child: BlocBuilder<PatientSearchBloc, PatientSearchState>(
                builder: (context, state) {
                  var list = state.list;

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final person = list[index];
                      return PatientCard(
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
