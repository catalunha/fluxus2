import 'package:flutter/material.dart';

import '../../core/utils/drop_down_abstract.dart';

class AppDropDownGeneric<T extends DropDrowAbstract> extends StatelessWidget {
  final String? title;
  final bool enabled;
  final List<T> options;
  final T? selected;
  final Function(T?) execute;
  final double height;
  final double width;
  const AppDropDownGeneric({
    Key? key,
    this.title,
    this.enabled = true,
    required this.options,
    this.selected,
    required this.execute,
    this.height = 30,
    this.width = 170,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        title != null ? Text(title!) : const SizedBox(),
        enabled
            ? Container(
                height: height,
                width: width,
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(style: BorderStyle.solid, width: 0.80),
                ),
                child: Center(
                  child: DropdownButton<T>(
                    value: selected,
                    icon: const Icon(Icons.arrow_downward),
                    underline: Container(
                      height: 0,
                      color: Colors.deepPurpleAccent,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    onChanged: (T? newValue) {
                      execute(newValue);
                    },
                    items: options.map<DropdownMenuItem<T>>((T value) {
                      return DropdownMenuItem<T>(
                        value: value,
                        child: Text(value.name!),
                        // child: Text('${value!.name} - ${value.description}'),
                      );
                    }).toList(),
                  ),
                ),
              )
            : const SizedBox(width: 50, height: 60),
      ],
    );
  }
}
