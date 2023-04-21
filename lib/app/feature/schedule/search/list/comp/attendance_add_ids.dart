import 'package:flutter/material.dart';

class AttendanceAddIds extends StatefulWidget {
  final String title;
  final String formFieldLabel;
  const AttendanceAddIds({
    Key? key,
    required this.title,
    required this.formFieldLabel,
  }) : super(key: key);

  @override
  State<AttendanceAddIds> createState() => _AttendanceAddIdsState();
}

class _AttendanceAddIdsState extends State<AttendanceAddIds> {
  final _formKey = GlobalKey<FormState>();
  final _objectIdTEC = TextEditingController();
  @override
  void initState() {
    super.initState();
    _objectIdTEC.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.title),
                // AppTextFormField(
                //   label: widget.formFieldLabel,
                //   controller: _objectIdTEC,
                //   validator:
                //       Validatorless.required('Esta informação é necessária'),
                // ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar')),
                    const SizedBox(
                      width: 50,
                    ),
                    TextButton(
                        onPressed: () async {
                          final formValid =
                              _formKey.currentState?.validate() ?? false;
                          if (formValid) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Executar')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
