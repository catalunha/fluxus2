import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:time_planner/time_planner.dart';

import '../../../../core/models/attendance_model.dart';
import '../../../../core/models/event_model.dart';
import '../bloc/schedule_search_bloc.dart';
import '../bloc/schedule_search_event.dart';
import '../bloc/schedule_search_state.dart';
import 'add/event_add_page.dart';
import 'confirm_presence/schedule_confirm_presence_page.dart';

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
      body: Column(
        children: [
          BlocBuilder<ScheduleSearchBloc, ScheduleSearchState>(
            builder: (context, state) {
              List<Widget> roomWidget = [];

              for (var room in state.rooms) {
                roomWidget.add(CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      room == state.roomSelected ? Colors.green : null,
                  child: IconButton(
                    icon: Text('${room.name}'),
                    onPressed: () {
                      context
                          .read<ScheduleSearchBloc>()
                          .add(ScheduleSearchEventFilterByRoom(room));
                    },
                  ),
                ));
              }

              return Wrap(
                children: roomWidget,
              );
            },
          ),
          BlocBuilder<ScheduleSearchBloc, ScheduleSearchState>(
            builder: (context, state) {
              if (state.listFiltered.isEmpty ||
                  state.start == null ||
                  state.end == null) {
                return const Center(child: Text(''));
                // const Center(
                //     child: Text('Eventos não encontrados nestas condições.'));
              }
              // print('room: ${state.roomSelected?.name}');
              // print('list: ${state.list.length}');
              // print('listFiltered: ${state.listFiltered}');
              var list = [...state.listFiltered];
              DateTime start = DateTime(
                  state.start!.year, state.start!.month, state.start!.day);
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
                timePlannerHeaders.add(
                  TimePlannerTitle(
                    date: dateFormat.format(dayMorning),
                    title: dateFormatDay.format(dayMorning),
                  ),
                );
                for (EventModel e in list) {
                  if (dayMorning.isBefore(e.start!) &&
                      dayNight.isAfter(e.start!)) {
                    List<String> texts = [];
                    List<String> tooltipMsgs = [];
                    bool allConfirmedPresence = false;
                    if (e.attendances?.length == 1) {
                      for (AttendanceModel attendance in e.attendances ?? []) {
                        texts.add('${attendance.professional?.nickname}');
                        texts.add('${attendance.patient?.nickname}');
                        allConfirmedPresence =
                            attendance.confirmedPresence == null ? false : true;
                      }
                    } else {
                      int confirmedPresence = 0;
                      for (AttendanceModel attendance in e.attendances ?? []) {
                        if (attendance.confirmedPresence != null) {
                          confirmedPresence++;
                        }
                        tooltipMsgs.add(
                            '${attendance.confirmedPresence != null ? "+" : "-"}${attendance.professional?.nickname} (${attendance.procedure?.code}) - ${attendance.patient?.nickname} ( ${attendance.healthPlan?.healthPlanType?.name}) ${attendance.patient?.phone}');
                        texts.add(
                            '${attendance.confirmedPresence != null ? "+" : "-"}${attendance.professional?.nickname}');
                      }
                      texts.add(
                          '$confirmedPresence/${e.attendances?.length} Cfm/Ats. ');
                      allConfirmedPresence =
                          confirmedPresence != e.attendances?.length
                              ? false
                              : true;
                    }
                    timePlannerTasks.add(
                      TimePlannerTask(
                        color:
                            allConfirmedPresence ? Colors.green : Colors.black,
                        dateTime: TimePlannerDateTime(
                          day: day,
                          hour: e.start!.hour,
                          minutes: e.start!.minute,
                        ),
                        minutesDuration: e.duration(),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: BlocProvider.of<ScheduleSearchBloc>(
                                      context),
                                  child: EventAddPage(model: e),
                                ),
                              ),
                            );
                          },
                          child: Tooltip(
                              message: tooltipMsgs.join('\n'),
                              child: Text(texts.join('\n'))),
                        ),
                        onTap: () async {
                          await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) {
                              // return ScheduleConfirmAttendancePage(
                              //     models: models);

                              return BlocProvider.value(
                                value: BlocProvider.of<ScheduleSearchBloc>(
                                    context),
                                child: ScheduleConfirmAttendancePage(event: e),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
                }
                day++;
              }
              Widget newPlanner = TimePlanner(
                key: ValueKey(state.listFiltered.hashCode),
                startHour: 6,
                endHour: 19,
                headers: timePlannerHeaders,
                tasks: timePlannerTasks,
              );
              return Expanded(child: newPlanner);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: BlocProvider.of<ScheduleSearchBloc>(context),
                child: const EventAddPage(model: null),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
