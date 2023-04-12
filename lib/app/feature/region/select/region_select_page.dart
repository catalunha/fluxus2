import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repositories/region_repository.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/region_select_bloc.dart';
import 'bloc/region_select_event.dart';
import 'bloc/region_select_state.dart';
import 'comp/region_card.dart';

class RegionSelectPage extends StatelessWidget {
  const RegionSelectPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => RegionRepository(),
      child: BlocProvider(
        create: (context) {
          return RegionSelectBloc(
            regionRepository: RepositoryProvider.of<RegionRepository>(context),
          );
        },
        child: const RegionSelectView(),
      ),
    );
  }
}

// class RegionSelectPage extends StatelessWidget {
//   const RegionSelectPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const RegionSelectView();
//   }
// }

class RegionSelectView extends StatefulWidget {
  const RegionSelectView({Key? key}) : super(key: key);

  @override
  State<RegionSelectView> createState() => _RegionSelectViewState();
}

class _RegionSelectViewState extends State<RegionSelectView> {
  final _formKey = GlobalKey<FormState>();
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
        title: const Text('Selecione uma região'),
      ),
      body: BlocListener<RegionSelectBloc, RegionSelectState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == RegionSelectStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == RegionSelectStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == RegionSelectStateStatus.loading) {
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
                      label: 'Nome da região',
                      controller: _nameTEC,
                      onChange: (value) {
                        context
                            .read<RegionSelectBloc>()
                            .add(RegionSelectEventFormSubmitted(value));
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context
                          .read<RegionSelectBloc>()
                          .add(RegionSelectEventFormSubmitted(_nameTEC.text));
                    },
                    icon: const Icon(Icons.youtube_searched_for_sharp),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BlocBuilder<RegionSelectBloc, RegionSelectState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.firstPage
                          ? null
                          : () {
                              context
                                  .read<RegionSelectBloc>()
                                  .add(RegionSelectEventPreviousPage());
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
                BlocBuilder<RegionSelectBloc, RegionSelectState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.lastPage
                          ? null
                          : () {
                              context
                                  .read<RegionSelectBloc>()
                                  .add(RegionSelectEventNextPage());
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
                child: BlocBuilder<RegionSelectBloc, RegionSelectState>(
                  builder: (context, state) {
                    var list = state.listFiltered;
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return RegionCard(
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
    );
  }
}
