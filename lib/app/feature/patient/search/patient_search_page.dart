import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repositories/patient_repository.dart';
import '../../utils/app_icon.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/patient_search_bloc.dart';
import 'bloc/patient_search_event.dart';
import 'bloc/patient_search_state.dart';
import 'list/patient_search_list_page.dart';

class PatientSearchPage extends StatelessWidget {
  const PatientSearchPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PatientRepository(),
      child: BlocProvider(
        create: (context) => PatientSearchBloc(
            userProfileRepository:
                RepositoryProvider.of<PatientRepository>(context)),
        child: const PatientSearchView(),
      ),
    );
  }
}

class PatientSearchView extends StatefulWidget {
  const PatientSearchView({Key? key}) : super(key: key);

  @override
  State<PatientSearchView> createState() => _SearchPageState();
}

class _SearchPageState extends State<PatientSearchView> {
  final _formKey = GlobalKey<FormState>();
  bool _nameContains = false;
  bool _phoneEqualTo = false;
  final _nameContainsTEC = TextEditingController();
  final _phoneEqualToTEC = TextEditingController();

  @override
  void initState() {
    _nameContainsTEC.text = '';
    _phoneEqualToTEC.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscando paciente'),
      ),
      body: BlocListener<PatientSearchBloc, PatientSearchState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          //print('++++++++++++++++ search -------------------');

          if (state.status == PatientSearchStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == PatientSearchStateStatus.success) {
            //print('success');
            Navigator.of(context).pop();
          }
          if (state.status == PatientSearchStateStatus.loading) {
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
                  children: [
                    Card(
                      child: Column(
                        children: [
                          const Text('por Nome'),
                          Row(
                            children: [
                              Checkbox(
                                value: _nameContains,
                                onChanged: (value) {
                                  setState(() {
                                    _nameContains = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: AppTextFormField(
                                  label: 'que contém',
                                  controller: _nameContainsTEC,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          const Text('por Telefone'),
                          Row(
                            children: [
                              Checkbox(
                                value: _phoneEqualTo,
                                onChanged: (value) {
                                  setState(() {
                                    _phoneEqualTo = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: AppTextFormField(
                                  label: 'igual a',
                                  controller: _phoneEqualToTEC,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 70)
                  ],
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
            context.read<PatientSearchBloc>().add(
                  PatientSearchEventFormSubmitted(
                    nameContainsBool: _nameContains,
                    nameContainsString: _nameContainsTEC.text,
                    phoneEqualToBool: _phoneEqualTo,
                    phoneEqualToString: _phoneEqualToTEC.text,
                  ),
                );
            // Navigator.of(context).pushNamed('/userProfile/list');

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<PatientSearchBloc>(context),
                  child: const PatientSearchListPage(),
                ),
              ),
            );

            /*
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<PatientSearchBloc>(context),
                  child: const PatientSearchListPage(),
                ),
              ),
            );
            */
            /*
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const PatientSearchListPage(),
              ),
            );
            */
          }
        },
      ),
    );
  }
}
