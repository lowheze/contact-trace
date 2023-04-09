import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_trace_3b/constants/style_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'edit_establishment.dart';

class EstablishmentAccountScreen extends StatelessWidget {
  EstablishmentAccountScreen(this.establishmentID, {Key? key})
      : super(key: key) {
    _reference =
        FirebaseFirestore.instance.collection('users').doc(establishmentID);
    _futureData = _reference.get();
  }

  String establishmentID;
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
            'Establishment Profile',
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
                              'Establishment Name:',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: '${data['estname']}',
                                border: OutlineInputBorder(),
                              ),
                              style: inputTextSize,
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
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: '${data['contactperson']}',
                                border: OutlineInputBorder(),
                              ),
                              style: inputTextSize,
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
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: '${data['estaddress']}',
                                border: OutlineInputBorder(),
                              ),
                              style: inputTextSize,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
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
                    data['uid'] = establishmentID;
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => EditEstablishmentInfo(data)));
                  },
                  child: Text('Edit Establishment Profile'))
            ],
          ),
        ));
  }
}
