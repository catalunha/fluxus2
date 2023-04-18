import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:time_planner/time_planner.dart';

import '../../../../core/models/event_model.dart';
import '../bloc/schedule_search_bloc.dart';
import '../bloc/schedule_search_state.dart';

class ScheduleSearchListPage extends StatelessWidget {
  const ScheduleSearchListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ScheduleSearchListView();
  }
}

class ScheduleSearchListView extends StatelessWidget {
  const ScheduleSearchListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos encontrados'),
        actions: [
          IconButton(
            onPressed: () {
              List<EventModel> modelList =
                  context.read<ScheduleSearchBloc>().state.list;
              Navigator.of(context)
                  .pushNamed('/event/print', arguments: modelList);
            },
            icon: const Icon(Icons.print),
          )
        ],
      ),
      body: BlocBuilder<ScheduleSearchBloc, ScheduleSearchState>(
        buildWhen: (current, next) =>
            next.list.isNotEmpty && next.start != null && next.end != null,
        // current.list.isNotEmpty &&
        // current.start != null &&
        // current.end != null,
        builder: (context, state) {
          print(state.list.length);
          print(state.start);
          print(state.end);
          if (state.list.isEmpty || state.start == null || state.end == null) {
            return const Center(child: Text('Construindo agenda...'));
          }
          var list = state.list;
          DateTime start =
              DateTime(state.start!.year, state.start!.month, state.start!.day);
          DateTime end =
              DateTime(state.end!.year, state.end!.month, state.end!.day);
          final dateFormat = DateFormat('dd/MM/y', 'pt_BR');
          final dateFormatDay = DateFormat('E', 'pt_BR');

          List<TimePlannerTask> timePlannerTasks = [];
          List<TimePlannerTitle> timePlannerHeaders = [];
          int day = 0;
          for (DateTime dayMorning = start;
              dayMorning.isBefore(end.add(const Duration(days: 1)));
              dayMorning = dayMorning.add(const Duration(days: 1))) {
            DateTime dayNight =
                dayMorning.add(const Duration(hours: 23, minutes: 59));
            timePlannerHeaders.add(TimePlannerTitle(
              date: dateFormat.format(dayMorning),
              title: dateFormatDay.format(dayMorning),
            ));
            for (EventModel e in list) {
              if (dayMorning.isBefore(e.start!) && dayNight.isAfter(e.start!)) {
                timePlannerTasks.add(
                  TimePlannerTask(
                    color: Colors.green,
                    dateTime: TimePlannerDateTime(
                      day: day,
                      hour: e.start!.hour,
                      minutes: e.start!.minute,
                    ),
                    minutesDuration: e.duration(),
                    child: Text('${e.id}'),
                  ),
                );
              } else {
                print('event ${e.id} nao esta neste dia $dayMorning');
              }
            }
            day++;
          }

          return TimePlanner(
            startHour: 6,
            endHour: 19,
            headers: timePlannerHeaders,
            tasks: timePlannerTasks,
          );
        },
      ),
    );
  }
}
