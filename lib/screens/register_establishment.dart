import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../constants/style_constants.dart';
import 'client.dart';
import 'establishment.dart';

class RegisterEstablishmentScreen extends StatefulWidget {
  const RegisterEstablishmentScreen({super.key});

  @override
  State<RegisterEstablishmentScreen> createState() =>
      _RegisterEstablishmentScreenState();
}

class _RegisterEstablishmentScreenState
    extends State<RegisterEstablishmentScreen> {
  final estnameController = TextEditingController();
  final estaddressController = TextEditingController();
  final contactPersonController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpassController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  var obscurePassword = true;

  final collectionPath = 'users';

  void registerEstablishment() async {
    try {
      EasyLoading.show(
        status: 'Processing...',
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (userCredential.user == null) {
        throw FirebaseAuthException(code: 'null-usercredential');
      }
      //created user account -> uid
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection(collectionPath).doc(uid).set({
        'estname': estnameController.text,
        "contactperson": contactPersonController.text,
        'estaddress': estaddressController.text,
        'type': 'establishment',
      });
      // await FirebaseFirestore.instance.collection('users').add(
      //   {
      //     'name': 'arni',
      //     'address': 'pangasinan',
      //     'type': 'client',
      //   },
      // );

      EasyLoading.showSuccess('User account has been registered.');
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => EstablishmentScreen(UserId: uid),
        ),
      );
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'weak-password') {
        EasyLoading.showError(
            'Your password is weak. Please enter more than 6 characters.');
        return;
      }
      if (ex.code == 'email-already-in-use') {
        EasyLoading.showError(
            ('Your password is already registered. Please enter a new email address.'));
        return;
      }
      if (ex.code == 'null-usercredential') {
        EasyLoading.showError(
            'An error occurred while creating your account. Please try again');
        return;
      }
      print(ex.code);
    }
  }

  void validateInput() {
    //cause form to validate
    if (_formkey.currentState!.validate()) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: null,
        title: 'Are you sure?',
        confirmBtnText: 'YES',
        cancelBtnText: 'No',
        onConfirmBtnTap: () {
          //yes
          Navigator.pop(context);
          registerEstablishment();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const inputTextSize = TextStyle(
      fontSize: 16,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up as Establishment',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/illustration.webp'),
              opacity: 0.4,
              alignment: Alignment.bottomCenter,
            ),
          ),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Register your account:'),
                const SizedBox(
                  height: 12.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required. Please enter your establishment name.';
                    }
                    return null;
                  },
                  controller: estnameController,
                  decoration: const InputDecoration(
                    labelText: 'Establishment Name',
                    border: OutlineInputBorder(),
                  ),
                  style: inputTextSize,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required. Please enter your contact person name.';
                    }
                    return null;
                  },
                  controller: contactPersonController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Person Name',
                    border: OutlineInputBorder(),
                  ),
                  style: inputTextSize,
                  minLines: 2,
                  maxLines: 5,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required. Please enter your establishment address.';
                    }
                    return null;
                  },
                  controller: estaddressController,
                  decoration: const InputDecoration(
                    labelText: 'Establishment Address',
                    border: OutlineInputBorder(),
                  ),
                  style: inputTextSize,
                  minLines: 2,
                  maxLines: 5,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required. Please enter an establishment email address.';
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                  style: inputTextSize,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter your password.';
                    }
                    if (value.length <= 6) {
                      return 'Password should be more than 6 characters.';
                    }
                    return null;
                  },
                  obscureText: obscurePassword,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: Icon(obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                  style: inputTextSize,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter your password.';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords don\'t match.';
                    }
                    return null;
                  },
                  obscureText: obscurePassword,
                  controller: confirmpassController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  style: inputTextSize,
                ),
                ElevatedButton(
                  onPressed: validateInput,
                  style: ElevatedButton.styleFrom(
                    shape: roundShape,
                  ),
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
