import 'package:contacts/model/contact.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxList<Contact> displayedContactList = <Contact>[].obs;
  HomeController(this.displayedContactList);

  void filterContactList(List<Contact> contacts, String searchTerm) {
    RxList<Contact> filteredContactList = <Contact>[].obs;
    filteredContactList.addAll(contacts);
    filteredContactList.retainWhere((contact) {
      return contact.name.toLowerCase().contains(searchTerm);
    });
    displayedContactList = filteredContactList;
  }
}
