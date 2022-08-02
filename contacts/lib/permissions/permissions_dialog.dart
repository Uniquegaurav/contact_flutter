import 'package:flutter/cupertino.dart';

class ContactPermissionWIdget extends StatelessWidget {
  const ContactPermissionWIdget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Permissions error'),
      content: const Text('Please enable contacts access '
          'permission in system settings'),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text('OK'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
