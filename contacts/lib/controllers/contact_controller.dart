import 'dart:typed_data';
import 'package:hive_flutter/adapters.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:contacts/model/contact.dart' as model;
import 'package:contacts/util/constants.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
// Provider class containing methods which invoke notifyListeners on call

class ContactController extends GetxController {
  final hiveBox = Hive.box(Constant.BOX_NAME);
  final hiveList = <model.Contact>[].obs;
  ContactController() {
    _loadContacts();
  }
  void _loadContacts() async {
    // final PermissionStatus permissionStatus =
    //     await Permissions.getContactPermission();
    // if (permissionStatus == PermissionStatus.granted) {
    // bool permissionGranted = await Permission.contacts.request().isGranted;
    // if (permissionGranted) {
    if (hiveBox.keys.isEmpty) {
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
        hiveBox.add(contactVal);
      }
      // }
    }
    for (int i = 0; i < hiveBox.keys.length; i++) {
      hiveList.add(hiveBox.getAt(i));
    }
    // }
    // notifyListeners();
  }

  void deleteContact(int index) {
    // await ContactsService.deleteContact(contact);
    hiveBox.deleteAt(index);
    hiveList.removeAt(index);
    // notifyListeners();
  }

  void addContact(model.Contact contact) {
    // await ContactsService.addContact(contact);
    hiveBox.add(contact);
    hiveList.add(contact);
    // notifyListeners();
  }

  void updateContact(int index, model.Contact contact) async {
    hiveBox.putAt(index, contact);
    hiveList[index] = contact;
    // notifyListeners();
  }

  get getContactList => hiveBox;
}
