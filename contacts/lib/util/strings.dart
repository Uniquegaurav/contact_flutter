class Strings {
  Strings._();
  static Strings? _instance;
  static Strings get instance => _instance ??= Strings._();
  final String addContact = 'Add Contact';
  final String yes = "Yes";
  final String cancel = "Cancel";
  final String saveChangesDialog = "Save changes";
  final String saveChangesMessage = "Save this contact?";
  final String invalidData = "Not a valid data";
  final String updateContact = 'Update Contact';
  final String firstNameLabel = ' First Name';
  final String lastNameLabel = 'Last Name';
  final String contactLabel = 'Contact number';
  final String pickImage = 'Pick an Image';
  final String deleteDialog = 'Delete contact';
  final String discardDialog = "Discard Changes";
  final String discardMessage = "discard your changes?";
  final String confirmDelete = 'Want to delete this contact?';
  final String emptyName = 'Name should not be empty';
  final String emptyPhone = 'Phone should not be empty';
  final String notFullName = 'Not a full Name';
  final String invalidNumber = "Contact Number is invalid";
}
