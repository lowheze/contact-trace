import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_trace_3b/constants/style_constants.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'edit_client.dart';
import 'edit_establishment.dart';

class ClientAccountScreen extends StatelessWidget {
  ClientAccountScreen(this.clientID, {Key? key}) : super(key: key) {
    _reference = FirebaseFirestore.instance.collection('users').doc(clientID);
    _futureData = _reference.get();
  }

  String clientID;
  late DocumentReference _reference;

  late Future<DocumentSnapshot> _futureData;
  late Map data;

  @override
  Widget build(BuildContext context) {
    const inputTextSize = TextStyle(
      fontSize: 16,
    );
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Client Profile',
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<DocumentSnapshot>(
                  future: _futureData,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('Some error occurred ${snapshot.error}'));
                    }
                    if (snapshot.hasData) {
                      DocumentSnapshot documentSnapshot = snapshot.data;
                      data = documentSnapshot.data() as Map;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text(
                              'First Name:',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: '${data['first name']}',
                                border: OutlineInputBorder(),
                              ),
                              style: inputTextSize,
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
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: '${data['middle name']}',
                                border: OutlineInputBorder(),
                              ),
                              style: inputTextSize,
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
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: '${data['last name']}',
                                border: OutlineInputBorder(),
                              ),
                              style: inputTextSize,
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
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: '${data['address']}',
                                border: OutlineInputBorder(),
                              ),
                              style: inputTextSize,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            // DateTimeFormField(
                            //   initialDate: bdate,
                            //   initialValue: bdate,
                            //   decoration: const InputDecoration(
                            //     labelText: 'Birthdate',
                            //     border: OutlineInputBorder(),
                            //     suffixIcon: Icon(Icons.event_note),
                            //   ),
                            //   mode: DateTimeFieldPickerMode.date,
                            //   autovalidateMode:
                            //       AutovalidateMode.onUserInteraction,
                            //   onDateSelected: (DateTime value) {
                            //     bdate = value;
                            //   },
                            // ),
                          ],
                        ),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
              ElevatedButton(
                  onPressed: () {
                    data['uid'] = clientID;
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => EditClientInfo(data)));
                  },
                  child: Text('Edit Client Profile'))
            ],
          ),
        ));
  }
}
