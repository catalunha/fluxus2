import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';

class Schedule extends StatelessWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TimePlannerTask> tasks = [
      TimePlannerTask(
        // background color for task
        color: Colors.purple,
        // day: Index of header, hour: Task will be begin at this hour
        // minutes: Task will be begin at this minutes
        dateTime: TimePlannerDateTime(day: 0, hour: 14, minutes: 00),
        // Minutes duration of task
        minutesDuration: 60,
        // Days duration of task (use for multi days task)
        // daysDuration: 2,
        onTap: () {},
        child: Text(
          'this is a task',
          style: TextStyle(color: Colors.grey[350], fontSize: 12),
        ),
      ),
      TimePlannerTask(
        // background color for task
        color: Colors.green,
        // day: Index of header, hour: Task will be begin at this hour
        // minutes: Task will be begin at this minutes
        dateTime: TimePlannerDateTime(day: 1, hour: 14, minutes: 30),
        // Minutes duration of task
        minutesDuration: 60,
        // Days duration of task (use for multi days task)
        // daysDuration: 2,
        onTap: () {},
        child: Text(
          'this is a task',
          style: TextStyle(color: Colors.grey[350], fontSize: 12),
        ),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
      ),
      body: TimePlanner(
        // time will be start at this hour on table
        startHour: 6,
        // time will be end at this hour on table
        endHour: 19,
        // each header is a column and a day
        headers: const [
          TimePlannerTitle(
            date: "10-03-2021",
            title: "sunday",
          ),
          TimePlannerTitle(
            date: "3/11/2021",
            title: "monday",
          ),
          TimePlannerTitle(
            date: "3/12/2021",
            title: "tuesday",
          ),
          TimePlannerTitle(
            date: "3/12/2021",
            title: "tuesday",
          ),
          TimePlannerTitle(
            date: "3/12/2021",
            title: "tuesday",
          ),
          TimePlannerTitle(
            date: "3/12/2021",
            title: "tuesday",
          ),
          TimePlannerTitle(
            date: "3/12/2021",
            title: "tuesday",
          ),
          TimePlannerTitle(
            date: "3/12/2021",
            title: "tuesday",
          ),
        ],
        // List of task will be show on the time planner
        tasks: tasks,
      ),
    );
  }
}
