import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditEstablishmentInfo extends StatelessWidget {
  EditEstablishmentInfo(this.establishmentInfo, {Key? key}) {
    estnameController =
        TextEditingController(text: establishmentInfo['estname']);
    contactPersonController =
        TextEditingController(text: establishmentInfo['contactperson']);
    estaddressController =
        TextEditingController(text: establishmentInfo['estaddress']);

    reference = FirebaseFirestore.instance
        .collection('users')
        .doc(establishmentInfo['uid']);
  }

  Map establishmentInfo;
  late DocumentReference reference;

  late TextEditingController estnameController;
  late TextEditingController estaddressController;
  late TextEditingController contactPersonController;
  late TextEditingController emailController;

  GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    const inputTextSize = TextStyle(
      fontSize: 16,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit establishment profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Establishment Name:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: estnameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                style: inputTextSize,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Establishment name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Contact Person Name:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: contactPersonController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                style: inputTextSize,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Contact person name is required';
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Establishment Address:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: estaddressController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                style: inputTextSize,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required';
                  }

                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      String estname = estnameController.text;
                      String contactperson = contactPersonController.text;
                      String estaddress = estaddressController.text;

                      //Create the Map of data
                      Map<String, String> dataToUpdate = {
                        'estname': estname,
                        'contactperson': contactperson,
                        'estaddress': estaddress,
                      };

                      //Call update()
                      reference.update(dataToUpdate);
                    }
                  },
                  child: Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}
