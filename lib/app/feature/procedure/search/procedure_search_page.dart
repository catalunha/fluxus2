import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repositories/procedure_repository.dart';
import '../../utils/app_icon.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/procedure_search_bloc.dart';
import 'bloc/procedure_search_event.dart';
import 'bloc/procedure_search_state.dart';
import 'list/procedure_search_list_page.dart';

class ProcedureSearchPage extends StatelessWidget {
  const ProcedureSearchPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ProcedureRepository(),
      child: BlocProvider(
        create: (context) => ProcedureSearchBloc(
          repository: RepositoryProvider.of<ProcedureRepository>(context),
        ),
        child: const ProcedureSearchView(),
      ),
    );
  }
}

class ProcedureSearchView extends StatefulWidget {
  const ProcedureSearchView({Key? key}) : super(key: key);

  @override
  State<ProcedureSearchView> createState() => _SearchPageState();
}

class _SearchPageState extends State<ProcedureSearchView> {
  final _formKey = GlobalKey<FormState>();
  bool _nameContainsBool = false;
  bool _codeEqualsToBool = false;
  final _nameContainsTEC = TextEditingController();
  final _codeEqualsToTEC = TextEditingController();

  @override
  void initState() {
    _nameContainsTEC.text = '';
    _codeEqualsToTEC.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscando procedimento'),
      ),
      body: BlocListener<ProcedureSearchBloc, ProcedureSearchState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == ProcedureSearchStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == ProcedureSearchStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == ProcedureSearchStateStatus.loading) {
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
                          const Text('por Código'),
                          Row(
                            children: [
                              Checkbox(
                                value: _codeEqualsToBool,
                                onChanged: (value) {
                                  setState(() {
                                    _codeEqualsToBool = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: AppTextFormField(
                                  label: 'igual a',
                                  controller: _codeEqualsToTEC,
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
                          const Text('por nome'),
                          Row(
                            children: [
                              Checkbox(
                                value: _nameContainsBool,
                                onChanged: (value) {
                                  setState(() {
                                    _nameContainsBool = value!;
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
            context
                .read<ProcedureSearchBloc>()
                .add(ProcedureSearchEventFormSubmitted(
                  nameContainsBool: _nameContainsBool,
                  nameContainsString: _nameContainsTEC.text,
                  codeEqualsToBool: _codeEqualsToBool,
                  codeEqualsToString: _codeEqualsToTEC.text,
                ));
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<ProcedureSearchBloc>(context),
                  child: const ProcedureSearchListPage(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class SearchCardText extends StatelessWidget {
  final String title;
  final String label;
  final bool isSelected;
  final Function(bool?)? selectedOnChanged;
  final TextEditingController controller;
  const SearchCardText({
    super.key,
    required this.title,
    required this.label,
    required this.isSelected,
    required this.controller,
    this.selectedOnChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(title),
          Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: selectedOnChanged,
              ),
              Expanded(
                child: AppTextFormField(
                  label: label,
                  controller: controller,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SearchCardBool extends StatelessWidget {
  final String title;
  final String label;
  final bool isSelected;
  final Function(bool?)? selectedOnChanged;
  final bool isSelectedValue;
  final Function(bool?)? selectedValueOnChanged;
  const SearchCardBool({
    super.key,
    required this.title,
    required this.label,
    required this.isSelected,
    this.selectedOnChanged,
    required this.isSelectedValue,
    this.selectedValueOnChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(title),
          Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: selectedOnChanged,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12,
                  ),
                  child: Row(
                    children: [
                      Text(label),
                      Checkbox(
                        value: isSelectedValue,
                        onChanged: selectedValueOnChanged,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
