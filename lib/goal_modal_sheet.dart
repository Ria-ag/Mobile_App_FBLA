import 'package:flutter/material.dart';

Future<void> goalModalSheet(BuildContext context, title, progressValue) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.grey[200],
    builder: (BuildContext context) {
      return const Text("hi!");
    }
  );
}