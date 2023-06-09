import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxus2/app/feature/utils/app_extension_size.dart';
import 'package:fluxus2/app/feature/utils/app_mixin_loader.dart';

import '../../../core/models/office_model.dart';
import '../../../core/repositories/office_repository.dart';
import '../../utils/app_mixin_message.dart';
import '../save/office_save_page.dart';
import 'bloc/office_list_bloc.dart';
import 'bloc/office_list_event.dart';
import 'bloc/office_list_state.dart';
import 'comp/office_card.dart';

class OfficeListPage extends StatelessWidget {
  const OfficeListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => OfficeRepository(),
      child: BlocProvider(
        create: (context) => OfficeListBloc(
            repository: RepositoryProvider.of<OfficeRepository>(context)),
        child: OfficeListView(),
      ),
    );
  }
}

class OfficeListView extends StatelessWidget
    with AppMixinLoader, AppMixinMessage {
  OfficeListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargos encontrados'),
        actions: [
          IconButton(
            onPressed: () {
              List<OfficeModel> modelList =
                  context.read<OfficeListBloc>().state.list;
              Navigator.of(context)
                  .pushNamed('/office/print', arguments: modelList);
            },
            icon: const Icon(Icons.print),
          )
        ],
      ),
      body: BlocListener<OfficeListBloc, OfficeListState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == OfficeListStateStatus.error) {
            // Navigator.of(context).pop();
            hideLoader(context);
            showMessage(context, state.error);
            // ScaffoldMessenger.of(context)
            //   ..hideCurrentSnackBar()
            //   ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == OfficeListStateStatus.success) {
            // Navigator.of(context).pop();
            hideLoader(context);
          }
          if (state.status == OfficeListStateStatus.loading) {
            showLoader(context);
            // await showDialog(
            //   barrierDismissible: false,
            //   context: context,
            //   builder: (BuildContext context) {
            //     return const Center(child: CircularProgressIndicator());
            //   },
            // );
          }
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BlocBuilder<OfficeListBloc, OfficeListState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.firstPage
                          ? null
                          : () {
                              context
                                  .read<OfficeListBloc>()
                                  .add(OfficeListEventPreviousPage());
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
                BlocBuilder<OfficeListBloc, OfficeListState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.lastPage
                          ? null
                          : () {
                              context
                                  .read<OfficeListBloc>()
                                  .add(OfficeListEventNextPage());
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
                child: BlocBuilder<OfficeListBloc, OfficeListState>(
                  builder: (context, state) {
                    var list = state.list;

                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return OfficeCard(
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
                  value: BlocProvider.of<OfficeListBloc>(context),
                  child: const OfficeSavePage(model: null),
                ),
              ),
            );
          },
          child: const Icon(Icons.add)),
    );
  }
}
