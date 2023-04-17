import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repositories/Attendance_repository.dart';
import '../../utils/app_icon.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/Attendance_search_bloc.dart';
import 'bloc/Attendance_search_event.dart';
import 'bloc/Attendance_search_state.dart';
import 'list/Attendance_search_list_page.dart';

class AttendanceSearchPage extends StatelessWidget {
  const AttendanceSearchPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AttendanceRepository(),
      child: BlocProvider(
        create: (context) {
          return AttendanceSearchBloc(
            AttendanceRepository:
                RepositoryProvider.of<AttendanceRepository>(context),
          );
        },
        child: const AttendanceSearchView(),
      ),
    );
  }
}

class AttendanceSearchView extends StatefulWidget {
  const AttendanceSearchView({Key? key}) : super(key: key);

  @override
  State<AttendanceSearchView> createState() => _SearchPageState();
}

class _SearchPageState extends State<AttendanceSearchView> {
  final _formKey = GlobalKey<FormState>();
  bool _ufContainsBool = false;
  bool _nameContainsBool = false;
  bool _cityContainsBool = false;
  final _ufContainsTEC = TextEditingController();
  final _nameContainsTEC = TextEditingController();
  final _cityContainsTEC = TextEditingController();

  @override
  void initState() {
    _ufContainsTEC.text = '';
    _nameContainsTEC.text = '';
    _cityContainsTEC.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscando regiões'),
      ),
      body: BlocListener<AttendanceSearchBloc, AttendanceSearchState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == AttendanceSearchStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == AttendanceSearchStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == AttendanceSearchStateStatus.loading) {
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
                          const Text('por uf'),
                          Row(
                            children: [
                              Checkbox(
                                value: _ufContainsBool,
                                onChanged: (value) {
                                  setState(() {
                                    _ufContainsBool = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: AppTextFormField(
                                  label: 'que contem',
                                  controller: _ufContainsTEC,
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
                          const Text('por Cidade'),
                          Row(
                            children: [
                              Checkbox(
                                value: _cityContainsBool,
                                onChanged: (value) {
                                  setState(() {
                                    _cityContainsBool = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: AppTextFormField(
                                  label: 'que contem',
                                  controller: _cityContainsTEC,
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
                .read<AttendanceSearchBloc>()
                .add(AttendanceSearchEventFormSubmitted(
                  ufContainsBool: _ufContainsBool,
                  ufContainsString: _ufContainsTEC.text,
                  cityContainsBool: _cityContainsBool,
                  cityContainsString: _cityContainsTEC.text,
                  nameContainsBool: _nameContainsBool,
                  nameContainsString: _nameContainsTEC.text,
                ));
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<AttendanceSearchBloc>(context),
                  child: const AttendanceSearchListPage(),
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
