import 'package:flutter/material.dart';

import '../../../../core/models/procedure_model.dart';

class ProcedureCard extends StatelessWidget {
  final ProcedureModel model;
  const ProcedureCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${model.code} - ${model.name}. R\$ ${model.cost}'),
      onTap: () => Navigator.of(context).pop(model),
    );
  }
}
