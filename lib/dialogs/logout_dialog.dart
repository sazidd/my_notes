import 'package:flutter/material.dart';
import 'package:my_notes/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are  you sure you want to log out?',
    optionBuilder: () => {
      'cancel': false,
      'Log Out': true,
    },
  ).then((value) => value ?? false);
}
