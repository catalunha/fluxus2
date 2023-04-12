import 'package:flutter/material.dart';

import '../../../../core/models/region_model.dart';

class RegionCard extends StatelessWidget {
  final RegionModel model;
  const RegionCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${model.name}. Em ${model.uf}: ${model.city}'),
      onTap: () => Navigator.of(context).pop(model),
    );
  }
}
