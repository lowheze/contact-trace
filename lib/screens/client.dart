import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../constants/style_constants.dart';
import 'client_acc_screen.dart';
import 'edit_client.dart';
import 'establishment_acc_screen.dart';

class ClientScreen extends StatelessWidget {
  final String UserId;

  const ClientScreen({super.key, required this.UserId});

  @override
  Widget build(BuildContext context) {
    String clientID = FirebaseAuth.instance.currentUser!.uid;
    var firestore_stream =
        FirebaseFirestore.instance.collection('logs').snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Client',
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
        actions: [
          DropdownButton(
            icon: Icon(Icons.more_vert),
            items: [
              DropdownMenuItem(
                child: Text(
                  'Logout',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                value: 'logout',
              ),
              DropdownMenuItem(
                child: Text(
                  'Account',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                value: 'account',
              ),
            ],
            onChanged: (val) {
              if (val == 'logout') {
                FirebaseAuth.instance.signOut();
              } else {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ClientAccountScreen(clientID)));
              }
            },
          )
        ],
      ),
      body: Center(
        child: QrImage(
          data: UserId,
          size: 300,
        ),
      ),
    );
  }
}
