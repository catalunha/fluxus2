import 'package:flutter/material.dart';

import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/graduation_model.dart';

class ExpertiseCard extends StatelessWidget {
  final ExpertiseModel model;
  const ExpertiseCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${model.name}'),
      onTap: () => Navigator.of(context).pop(model),
    );
  }
}
