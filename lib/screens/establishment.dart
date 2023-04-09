import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_trace_3b/constants/style_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'establishment_acc_screen.dart';

class EstablishmentScreen extends StatelessWidget {
  final String UserId;
  EstablishmentScreen({super.key, required this.UserId});

  String establishmentID = FirebaseAuth.instance.currentUser!.uid;
  
  void QrScan() async {
    final collectionPath = 'users';
    String cancelButtonText = 'CANCEL';
    String colorCode = '#ffffff';
    bool isShowFlashIcon = true;
    ScanMode scanMode = ScanMode.QR;
    String qrScanRes = await FlutterBarcodeScanner.scanBarcode(
        colorCode, cancelButtonText, isShowFlashIcon, scanMode);
    if (qrScanRes != '-1') {
      EasyLoading.show(status: "Processing... ");
      try {
        FirebaseFirestore.instance
            .collection(collectionPath)
            .doc(qrScanRes)
            .get()
            .then(
          (value) {
            FirebaseFirestore.instance.collection(logPath).add(
              {
                "clientId": qrScanRes,
                "clientName": "${value['lname']}, ${value['fname']}",
                "estId": UserId,
                "visitDate": DateTime.now(),
              },
            );
          },
        );

        EasyLoading.showSuccess("QR Code scanned successfully! ");
      } catch (e) {
        EasyLoading.showError("Invalid QR code. ");
      }
    } else {
      EasyLoading.showError("Invalid QR code. ");
    }
  }

  @override
  Widget build(BuildContext context) {
    var firestore_stream =
        FirebaseFirestore.instance.collection('logs').snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Establishment',
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
                        builder: (context) =>
                            EstablishmentAccountScreen(establishmentID)));
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () async {
                  String COLOR_CODE = '#ffffff';
                  String CANCEL_BUTTON_TEXT = 'CANCEL';
                  bool isShowFlashIcon = true;
                  ScanMode scanMode = ScanMode.DEFAULT;
                  String qr = await FlutterBarcodeScanner.scanBarcode(
                      COLOR_CODE,
                      CANCEL_BUTTON_TEXT,
                      isShowFlashIcon,
                      scanMode);
                  print(qr);
                  if (qr != '-1') {
                    //log firestore
                    EasyLoading.show(status: 'Processing...');
                    String collectionPath = 'logs';
                    FirebaseFirestore.instance.collection(collectionPath).add({
                      'client_uid': qr,
                      'establishment_uid':
                          FirebaseAuth.instance.currentUser!.uid,
                      'datetime': DateTime.now(),
                    });
                    EasyLoading.showSuccess('QR Code logged successfully.');
                  }
                },
                style: ElevatedButton.styleFrom(shape: roundShape),
                child: const Text('Scan'),
              ),
              Expanded(
                  child: StreamBuilder(
                      stream: firestore_stream,
                      builder: (context, snapshot) {
                        //check for waiting status
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        var documents = snapshot.data!.docs;
                        return ListView.builder(
                          itemBuilder: (context, index) =>
                              Text(documents[index]['client_uid'].toString()),
                          itemCount: documents.length,
                        );
                      })),
              // Center(
              //   child: QrImage(
              //     data: UserId,
              //     size: 300,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
