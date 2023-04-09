import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditClientInfo extends StatelessWidget {
  EditClientInfo(this.clientInfo, {Key? key}) {
    fnameController = TextEditingController(text: clientInfo['first name']);
    mnameController = TextEditingController(text: clientInfo['middle name']);
    lnameController = TextEditingController(text: clientInfo['last name']);
    addressController = TextEditingController(text: clientInfo['address']);

    reference =
        FirebaseFirestore.instance.collection('users').doc(clientInfo['uid']);
  }

  Map clientInfo;
  late DocumentReference reference;

  late TextEditingController fnameController;
  late TextEditingController mnameController;
  late TextEditingController lnameController;
  late TextEditingController addressController;

  GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    const inputTextSize = TextStyle(
      fontSize: 16,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit profile',
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
                'First Name:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: fnameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                style: inputTextSize,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Middle Name:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: mnameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                style: inputTextSize,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Middle name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Last Name:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: lnameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                style: inputTextSize,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Last name is required';
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Address:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: addressController,
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
                      String fname = fnameController.text;
                      String mname = mnameController.text;
                      String lname = lnameController.text;
                      String address = addressController.text;

                      //Create the Map of data
                      Map<String, String> dataToUpdate = {
                        'first name': fname,
                        'middle name': mname,
                        'last name': lname,
                        'address': address,
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
