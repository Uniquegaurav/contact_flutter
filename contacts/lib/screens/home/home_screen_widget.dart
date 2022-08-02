import 'package:contacts/screens/update/update_screen.dart';
import 'package:contacts/util/basic_util.dart';
import 'package:flutter/material.dart';
import 'package:contacts/model/contact.dart';
import 'package:get/get.dart';
import '../../controllers/contact_controller.dart';
import '../../util/strings.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  final contactController = Get.put(ContactController());
  @override
  Widget build(BuildContext context) {
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
                    : contactController.addContact(newContact);
              },
              icon: const Icon(Icons.add),
              iconSize: 30.0,
            ),
          ),
        ],
      ),
      body: const ContactListWIdget(),
    );
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
  TextEditingController searchController = TextEditingController();
  RxList<Contact> filteredContactList = <Contact>[].obs;
  RxList<Contact> contacts = <Contact>[].obs;
  final contactController = Get.find<ContactController>();
  @override
  void initState() {
    super.initState();
    contacts = contactController.hiveList;
  }

  filterContact() {
    List<Contact> filter = [];
    // filteredContactList.clear();
    filter.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      filter.retainWhere((contact) {
        return contact.name
            .toLowerCase()
            .contains(searchController.text.toLowerCase());
      });
    }
    setState(() {
      filteredContactList.clear();
      filteredContactList.addAll(filter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      searchController.addListener(() {
        filterContact();
      });
      // var contacts = contactController.hiveList;
      // final homeController = Get.put(HomeController(contacts));
      // searchController.addListener(() {
      //   filterContact(contacts);
      // });er
      // if (searchController.text.isNotEmpty) {
      //   contacts = contactListProvider
      //       .getFilteredContactList(searchController.text.toLowerCase());
      // }

      // contacts = displayedContact;
      // filteredContactList = [];
      // filteredContactList.addAll(contacts);
      // searchController.addListener(() {
      //   if (searchController.text.isNotEmpty) {
      //     filteredContactList.retainWhere((contact) {
      //       return contact.name
      //           .toLowerCase()
      //           .contains(searchController.text.toLowerCase());
      //     });
      //   }
      // });
      bool isSearching = searchController.text.isNotEmpty;

      return Container(
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.pinkAccent),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    prefixIcon: const Icon(Icons.search)),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount:
                    isSearching ? filteredContactList.length : contacts.length,
                itemBuilder: ((context, index) {
                  Contact contact = isSearching
                      ? filteredContactList[index]
                      : contacts[index];
                  String initals = BasicUtil.getNameInitials(contact.name);
                  return ListTile(
                    onTap: () async {
                      Contact? newContact = await Navigator.push(context,
                          MaterialPageRoute(builder: ((context) {
                        return UpdatePage(contact: contact);
                      })));
                      newContact == null
                          ? null
                          : contactController.updateContact(index, newContact);
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
                                  contactController.deleteContact(index);
                                  Navigator.of(ctx).pop();
                                  Get.snackbar(
                                    'Deleted',
                                    '${contact.name} deleted',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );
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
    });
  }
}
