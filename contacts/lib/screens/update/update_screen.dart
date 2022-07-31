import 'package:contacts/util/basic_util.dart';
import 'package:contacts/util/constants.dart';
import 'package:contacts/util/form_validation.dart';
import 'package:flutter/material.dart';
import 'package:contacts/model/contact.dart';
import 'dart:typed_data';

import '../../util/strings.dart';

class UpdatePage extends StatefulWidget {
  final Contact? contact;
  const UpdatePage({Key? key, this.contact}) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String contactName;
    String contactNumber;
    Uint8List? contactAvatar;
    final formKey = GlobalKey<FormState>();
    if (widget.contact == null) {
      contactName = "";
      contactNumber = "";
    } else {
      contactName = widget.contact!.name;
      contactNumber = widget.contact!.number;
      if (widget.contact!.avatar != null) {
        contactAvatar = widget.contact!.avatar;
      }
    }
    Contact newContact = Contact(
        name: contactName, number: contactNumber, avatar: contactAvatar);

    nameController.text = contactName;
    // nameController.selection = TextSelection.fromPosition(
    //   TextPosition(offset: contactName.length),
    // );
    numberController.text = contactNumber;
    // nameController.selection = TextSelection.fromPosition(
    //   TextPosition(offset: contactNumber.length),
    // );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 109, 148, 67),
          centerTitle: true,
          title: const Text('Edit'),
          leading: IconButton(
            onPressed: () {
              Strings strings = Strings.instance;
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(strings.discardDialog),
                  content: Text(strings.discardMessage),
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
                        Navigator.of(ctx).pop();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.close),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Strings strings = Strings.instance;
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(strings.saveChangesDialog),
                    content: Text(strings.saveChangesMessage),
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
                          Navigator.of(ctx).pop();
                          if (formKey.currentState!.validate()) {
                            Contact newContactReturn = Contact(
                                name: nameController.text.trim(),
                                number: numberController.text.trim());
                            Navigator.pop(context, newContactReturn);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(strings.invalidData)),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );

                // need to use controller and pass data to home
              },
              icon: const Icon(Icons.done),
            ),
          ],
        ),
        body: FormWidget(
          nameController: nameController,
          numberController: numberController,
          contact: newContact,
          formKey: formKey,
        ));
  }
}

class FormWidget extends StatefulWidget {
  final TextEditingController numberController;
  final TextEditingController nameController;
  final Contact? contact;
  final GlobalKey<FormState> formKey;
  const FormWidget(
      {Key? key,
      required this.nameController,
      required this.numberController,
      required this.contact,
      required this.formKey})
      : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  @override
  Widget build(BuildContext context) {
    String initials = "AB";
    if (widget.contact!.name.isEmpty) {
      initials = "NC";
    } else {
      initials = BasicUtil.getNameInitials(widget.contact!.name);
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 10.0, 30.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(2),
              child: Center(
                child: (widget.contact?.avatar != null &&
                        (widget.contact?.avatar)!.isNotEmpty)
                    ? CircleAvatar(
                        radius: 150,
                        backgroundImage: MemoryImage((widget.contact?.avatar)!),
                      )
                    : CircleAvatar(
                        radius: 150,
                        backgroundImage:
                            const NetworkImage(Constant.BACKGROUND_IMAGE_URL),
                        backgroundColor: const Color.fromARGB(255, 114, 86, 44),
                        child: Text(
                          initials,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 100),
                        ),
                      ),
              ),
            ),
            Container(
              // color: const Color.fromARGB(255, 169, 71, 100),
              margin: const EdgeInsets.only(top: 20),
              width: 360,
              height: 60,
              child: Center(
                child: Text(
                  initials == "NC" ? "New Contact" : '${widget.contact?.name}',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.green[900],
                    fontWeight: FontWeight.w500,
                  ), //Textstyle
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  const Expanded(
                      flex: 1, child: Icon(Icons.contacts, size: 34)),
                  Expanded(
                    flex: 7,
                    child: TextFormField(
                      controller: widget.nameController,
                      decoration: InputDecoration(
                          hintText: widget.contact == null
                              ? ""
                              : widget.contact?.name,
                          contentPadding:
                              const EdgeInsets.fromLTRB(15, 8, 8, 0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(23.0)),
                          labelText: "Full Name"),
                      validator: (value) {
                        return FormValidation.nameValidator(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  const Expanded(
                      flex: 1, child: Icon(Icons.phone_iphone, size: 34)),
                  Expanded(
                    flex: 7,
                    child: TextFormField(
                      controller: widget.numberController,
                      decoration: InputDecoration(
                          hintText: widget.contact == null
                              ? ""
                              : widget.contact?.number,
                          contentPadding:
                              const EdgeInsets.fromLTRB(15, 8, 8, 0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(23.0)),
                          labelText: "Phone"),
                      validator: (value) {
                        return FormValidation.phoneValidator(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
