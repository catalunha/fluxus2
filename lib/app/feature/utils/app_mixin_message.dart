import 'package:flutter/material.dart';

mixin AppMixinMessage {
  void showMessage(BuildContext context, String? message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message ?? '...')));
  }
}
