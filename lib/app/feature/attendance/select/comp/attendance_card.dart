import 'package:flutter/material.dart';

import '../../../../core/models/Attendance_model.dart';

class AttendanceCard extends StatelessWidget {
  final AttendanceModel model;
  const AttendanceCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${model.name}. Em ${model.uf}: ${model.city}'),
      onTap: () => Navigator.of(context).pop(model),
    );
  }
}
