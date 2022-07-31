import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:contacts/model/contact.dart' as model;
import 'package:contacts/util/constants.dart';
// import 'package:contacts/permissions/permission_handler.dart';
// import 'package:permission_handler/permission_handler.dart';
// Provider class containing methods which invoke notifyListeners on call

class ContactProvider extends ChangeNotifier {
  ContactProvider() {
    _loadContacts();
  }
  void _loadContacts() async {
    // final PermissionStatus permissionStatus =
    //     await Permissions.getContactPermission();
    // if (permissionStatus == PermissionStatus.granted) {
    if (Hive.box(Constant.BOX_NAME).keys.isEmpty) {
      List<Contact> contacts = await ContactsService.getContacts();
      for (var contact in contacts) {
        String contactName = contact.displayName ?? "";
        String contactNumber = contact.phones == null
            ? ""
            : (contact.phones!.isEmpty
                ? ""
                : contact.phones!.elementAt(0).value!);
        Uint8List? contactAvatar = contact.avatar;
        model.Contact contactVal = model.Contact(
            name: contactName, number: contactNumber, avatar: contactAvatar);
        Hive.box(Constant.BOX_NAME).add(contactVal);
      }
      // }
    }
    notifyListeners();
  }

  void deleteContact(int index) {
    // await ContactsService.deleteContact(contact);
    Hive.box(Constant.BOX_NAME).deleteAt(index);
    notifyListeners();
  }

  void addContact(model.Contact contact) {
    // await ContactsService.addContact(contact);
    Hive.box(Constant.BOX_NAME).add(contact);
    notifyListeners();
  }

  void updateContact(int index, model.Contact contact) async {
    Hive.box(Constant.BOX_NAME).putAt(index, contact);
    notifyListeners();
  }

  get getContactList => Hive.box(Constant.BOX_NAME);
}
