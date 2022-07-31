import 'package:contacts/screens/update/update_screen.dart';
import 'package:contacts/util/basic_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contacts/model/contact.dart';

import '../../util/contact_provider.dart';
import '../../util/strings.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ContactProvider>(
        builder: ((context, contactListProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
          backgroundColor: const Color.fromARGB(255, 109, 148, 67),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: () async {
                  Contact? newContact = await Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    return const UpdatePage();
                  })));
                  newContact == null
                      ? null
                      : contactListProvider.addContact(newContact);
                },
                icon: const Icon(Icons.add),
                iconSize: 30.0,
              ),
            ),
          ],
        ),
        body: const ContactListWIdget(),
      );
    }));
  }
}

class ContactListWIdget extends StatefulWidget {
  const ContactListWIdget({
    Key? key,
  }) : super(key: key);

  @override
  State<ContactListWIdget> createState() => _ContactListWIdgetState();
}

class _ContactListWIdgetState extends State<ContactListWIdget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ContactProvider>(
        builder: ((context, contactListProvider, child) {
      final contacts = contactListProvider.getContactList;
      return Container(
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
        child: ListView(
          children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                itemCount: contacts.length,
                itemBuilder: ((context, index) {
                  Contact contact = contacts.getAt(index);
                  String initals = BasicUtil.getNameInitials(contact.name);
                  return ListTile(
                    onTap: () async {
                      Contact? newContact = await Navigator.push(context,
                          MaterialPageRoute(builder: ((context) {
                        return UpdatePage(contact: contact);
                      })));
                      newContact == null
                          ? null
                          : contactListProvider.updateContact(
                              index, newContact);
                    },
                    title: Text(contact.name),
                    subtitle: Text(contact.number),
                    leading:
                        (contact.avatar != null && (contact.avatar)!.isNotEmpty)
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(contact.avatar!),
                              )
                            : CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(255, 100, 128, 72),
                                child: Text(
                                  initals,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                    trailing: IconButton(
                      onPressed: () {
                        Strings strings = Strings.instance;
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(strings.deleteDialog),
                            content: Text(strings.confirmDelete),
                            actions: <Widget>[
                              TextButton(
                                child: Text(strings.cancel),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              TextButton(
                                child: Text(strings.yes),
                                onPressed: () {
                                  contactListProvider.deleteContact(index);
                                  Navigator.of(ctx).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete),
                      color: const Color.fromARGB(255, 90, 130, 48),
                      iconSize: 23,
                    ),
                  );
                }))
          ],
        ),
      );
    }));
  }
}
