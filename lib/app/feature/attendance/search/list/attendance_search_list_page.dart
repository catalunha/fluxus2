import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/attendance_model.dart';
import '../bloc/attendance_search_bloc.dart';
import '../bloc/attendance_search_event.dart';
import '../bloc/attendance_search_state.dart';
import 'comp/attendance_card.dart';

class AttendanceSearchListPage extends StatelessWidget {
  const AttendanceSearchListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AttendanceSearchListView();
  }
}

class AttendanceSearchListView extends StatelessWidget {
  const AttendanceSearchListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atendimentos encontrados'),
        actions: [
          IconButton(
            onPressed: () {
              List<AttendanceModel> modelList =
                  context.read<AttendanceSearchBloc>().state.list;
              Navigator.of(context)
                  .pushNamed('/attendance/print', arguments: modelList);
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
              BlocBuilder<AttendanceSearchBloc, AttendanceSearchState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: state.firstPage
                        ? null
                        : () {
                            context
                                .read<AttendanceSearchBloc>()
                                .add(AttendanceSearchEventPreviousPage());
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
              BlocBuilder<AttendanceSearchBloc, AttendanceSearchState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: state.lastPage
                        ? null
                        : () {
                            context
                                .read<AttendanceSearchBloc>()
                                .add(AttendanceSearchEventNextPage());
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
              child: BlocBuilder<AttendanceSearchBloc, AttendanceSearchState>(
                builder: (context, state) {
                  var list = state.list;
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
    );
  }
}
