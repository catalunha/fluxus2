import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/attendance_repository.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/attendance_select_bloc.dart';
import 'bloc/attendance_select_event.dart';
import 'bloc/attendance_select_state.dart';
import 'comp/attendance_card.dart';

class AttendanceSelectPage extends StatelessWidget {
  final bool isSingleValue;
  const AttendanceSelectPage({
    Key? key,
    required this.isSingleValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AttendanceRepository(),
      child: BlocProvider(
        create: (context) {
          UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.userProfile!;
          return AttendanceSelectBloc(
            repository: RepositoryProvider.of<AttendanceRepository>(context),
            seller: userProfile,
            isSingleValue: isSingleValue,
          );
        },
        child: const AttendanceSelectView(),
      ),
    );
  }
}

class AttendanceSelectView extends StatefulWidget {
  const AttendanceSelectView({Key? key}) : super(key: key);

  @override
  State<AttendanceSelectView> createState() => _AttendanceSelectViewState();
}

class _AttendanceSelectViewState extends State<AttendanceSelectView> {
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
        title: const Text('Selecione uma graduação'),
      ),
      body: BlocListener<AttendanceSelectBloc, AttendanceSelectState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == AttendanceSelectStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == AttendanceSelectStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == AttendanceSelectStateStatus.loading) {
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
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: AppTextFormField(
                      label: 'Pesquise por Nome',
                      controller: _nameTEC,
                      onChange: (value) {
                        context
                            .read<AttendanceSelectBloc>()
                            .add(AttendanceSelectEventFormSubmitted(value));
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<AttendanceSelectBloc>().add(
                          AttendanceSelectEventFormSubmitted(_nameTEC.text));
                    },
                    icon: const Icon(Icons.youtube_searched_for_sharp),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BlocBuilder<AttendanceSelectBloc, AttendanceSelectState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.firstPage
                          ? null
                          : () {
                              context
                                  .read<AttendanceSelectBloc>()
                                  .add(AttendanceSelectEventPreviousPage());
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
                BlocBuilder<AttendanceSelectBloc, AttendanceSelectState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.lastPage
                          ? null
                          : () {
                              context
                                  .read<AttendanceSelectBloc>()
                                  .add(AttendanceSelectEventNextPage());
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
                child: BlocBuilder<AttendanceSelectBloc, AttendanceSelectState>(
                  builder: (context, state) {
                    var list = state.listFiltered;
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return AttendanceCard(
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
          BlocBuilder<AttendanceSelectBloc, AttendanceSelectState>(
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
