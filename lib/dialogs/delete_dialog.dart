import 'package:flutter/material.dart';
import 'package:my_notes/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Are  you sure you want to delete this item?',
    optionBuilder: () => {
      'cancel': false,
      'yes': true,
    },
  ).then((value) => value ?? false);
}
