import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repositories/procedure_repository.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/procedure_select_bloc.dart';
import 'bloc/procedure_select_event.dart';
import 'bloc/procedure_select_state.dart';
import 'comp/procedure_card.dart';

class ProcedureSelectPage extends StatelessWidget {
  final bool isSingleValue;

  const ProcedureSelectPage({
    Key? key,
    required this.isSingleValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ProcedureRepository(),
      child: BlocProvider(
        create: (context) {
          return ProcedureSelectBloc(
            repository: RepositoryProvider.of<ProcedureRepository>(context),
            isSingleValue: isSingleValue,
          );
        },
        child: const ProcedureSelectView(),
      ),
    );
  }
}

class ProcedureSelectView extends StatefulWidget {
  const ProcedureSelectView({Key? key}) : super(key: key);

  @override
  State<ProcedureSelectView> createState() => _ProcedureSelectViewState();
}

class _ProcedureSelectViewState extends State<ProcedureSelectView> {
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
      body: BlocListener<ProcedureSelectBloc, ProcedureSelectState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == ProcedureSelectStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == ProcedureSelectStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == ProcedureSelectStateStatus.loading) {
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
                            .read<ProcedureSelectBloc>()
                            .add(ProcedureSelectEventFormSubmitted(value));
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<ProcedureSelectBloc>().add(
                          ProcedureSelectEventFormSubmitted(_nameTEC.text));
                    },
                    icon: const Icon(Icons.youtube_searched_for_sharp),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BlocBuilder<ProcedureSelectBloc, ProcedureSelectState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.firstPage
                          ? null
                          : () {
                              context
                                  .read<ProcedureSelectBloc>()
                                  .add(ProcedureSelectEventPreviousPage());
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
                BlocBuilder<ProcedureSelectBloc, ProcedureSelectState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.lastPage
                          ? null
                          : () {
                              context
                                  .read<ProcedureSelectBloc>()
                                  .add(ProcedureSelectEventNextPage());
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
                child: BlocBuilder<ProcedureSelectBloc, ProcedureSelectState>(
                  builder: (context, state) {
                    var list = state.listFiltered;
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
      ),
      floatingActionButton:
          BlocBuilder<ProcedureSelectBloc, ProcedureSelectState>(
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
