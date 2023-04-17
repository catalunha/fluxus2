import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repositories/patient_repository.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/patient_select_bloc.dart';
import 'bloc/patient_select_event.dart';
import 'bloc/patient_select_state.dart';
import 'comp/patient_card.dart';

class PatientSelectPage extends StatelessWidget {
  final bool isSingleValue;

  const PatientSelectPage({
    Key? key,
    required this.isSingleValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PatientRepository(),
      child: BlocProvider(
        create: (context) {
          return PatientSelectBloc(
            repository: RepositoryProvider.of<PatientRepository>(context),
            isSingleValue: isSingleValue,
          );
        },
        child: const PatientSelectView(),
      ),
    );
  }
}

class PatientSelectView extends StatefulWidget {
  const PatientSelectView({Key? key}) : super(key: key);

  @override
  State<PatientSelectView> createState() => _PatientSelectViewState();
}

class _PatientSelectViewState extends State<PatientSelectView> {
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
      body: BlocListener<PatientSelectBloc, PatientSelectState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == PatientSelectStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == PatientSelectStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == PatientSelectStateStatus.loading) {
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
                            .read<PatientSelectBloc>()
                            .add(PatientSelectEventFormSubmitted(value));
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context
                          .read<PatientSelectBloc>()
                          .add(PatientSelectEventFormSubmitted(_nameTEC.text));
                    },
                    icon: const Icon(Icons.youtube_searched_for_sharp),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BlocBuilder<PatientSelectBloc, PatientSelectState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.firstPage
                          ? null
                          : () {
                              context
                                  .read<PatientSelectBloc>()
                                  .add(PatientSelectEventPreviousPage());
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
                BlocBuilder<PatientSelectBloc, PatientSelectState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.lastPage
                          ? null
                          : () {
                              context
                                  .read<PatientSelectBloc>()
                                  .add(PatientSelectEventNextPage());
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
                child: BlocBuilder<PatientSelectBloc, PatientSelectState>(
                  builder: (context, state) {
                    var list = state.listFiltered;
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return PatientCard(
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
      floatingActionButton: BlocBuilder<PatientSelectBloc, PatientSelectState>(
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
