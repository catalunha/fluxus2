import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repositories/event_repository.dart';
import '../../utils/app_icon.dart';
import 'bloc/event_search_bloc.dart';
import 'bloc/event_search_event.dart';
import 'bloc/event_search_state.dart';
import 'list/event_search_list_page.dart';

class EventSearchPage extends StatelessWidget {
  const EventSearchPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => EventRepository(),
      child: BlocProvider(
        create: (context) => EventSearchBloc(
            repository: RepositoryProvider.of<EventRepository>(context)),
        child: const EventSearchView(),
      ),
    );
  }
}

class EventSearchView extends StatefulWidget {
  const EventSearchView({Key? key}) : super(key: key);

  @override
  State<EventSearchView> createState() => _SearchPageState();
}

class _SearchPageState extends State<EventSearchView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscando evento'),
      ),
      body: BlocListener<EventSearchBloc, EventSearchState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          //print('++++++++++++++++ search -------------------');

          if (state.status == EventSearchStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == EventSearchStateStatus.success) {
            //print('success');
            Navigator.of(context).pop();
          }
          if (state.status == EventSearchStateStatus.loading) {
            //print('loading');

            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: const [SizedBox(height: 70)],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Executar busca',
        child: const Icon(AppIconData.search),
        onPressed: () async {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            context.read<EventSearchBloc>().add(
                  EventSearchEventFormSubmitted(),
                );

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<EventSearchBloc>(context),
                  child: const EventSearchListPage(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
