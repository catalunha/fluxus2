import 'package:flutter/material.dart';

import '../../../../core/models/graduation_model.dart';

class GraduationCard extends StatelessWidget {
  final GraduationModel model;
  const GraduationCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${model.name}'),
      onTap: () => Navigator.of(context).pop(model),
    );
  }
}
