import 'package:contact_trace_3b/firebase_options.dart';
import 'package:contact_trace_3b/screens/client.dart';
import 'package:contact_trace_3b/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

//!!! CONTACT TRACING APP
//TODO
//!1. Registration both a) clients/users and b) establishments
//2. Login a) clients and b) establishments
//3. Generate QR codes
//4. Scan QR codes
//5. Trace contacts

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ContactTrace());
}

class ContactTrace extends StatelessWidget {
  const ContactTrace({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.montserrat().fontFamily,
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black45,
          ),
          displayMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[200],
          elevation: 0,
        ),
      ),
      home: StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //check if the snapshot has data; means use logged
          if (snapshot.hasData) {
            var uid = FirebaseAuth.instance.currentUser!.uid;
            print(uid);
            return ClientScreen(UserId: uid);
            //TODO : navigate to EstablishmentScreen if the user is establishment
          }
          return HomeScreen();
          // return Scaffold();
        },
        stream: FirebaseAuth.instance.authStateChanges(),
        // child: const HomeScreen(),
      ),
      builder: EasyLoading.init(),
    );
  }
}
