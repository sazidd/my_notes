import 'package:flutter/material.dart';
import 'package:my_notes/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'You Cannot Share an empty note!',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
