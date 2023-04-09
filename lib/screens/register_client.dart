import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_trace_3b/constants/style_constants.dart';
import 'package:contact_trace_3b/screens/client.dart';
import 'package:date_field/date_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quickalert/quickalert.dart';

class RegisterClientScreen extends StatefulWidget {
  const RegisterClientScreen({super.key});

  @override
  State<RegisterClientScreen> createState() => _RegisterClientScreenState();
}

class _RegisterClientScreenState extends State<RegisterClientScreen> {
  final fnameController = TextEditingController();
  final mnameController = TextEditingController();
  final lnameController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  late final DateTime bdate;
  final passwordController = TextEditingController();
  final confirmpassController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  var obscurePassword = true;

  final collectionPath = 'users';

  void registerClient() async {
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
        'first name': fnameController.text,
        'middle name': mnameController.text,
        'last name': lnameController.text,
        'address': addressController.text,
        "bdate": bdate,
        'type': 'client',
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
          builder: (context) => ClientScreen(UserId: uid),
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
          registerClient();
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
          'Sign Up as Client',
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
                      return 'Required. Please enter your first name.';
                    }
                    return null;
                  },
                  controller: fnameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
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
                      return 'Required. Please enter your middle name.';
                    }
                    return null;
                  },
                  controller: mnameController,
                  decoration: const InputDecoration(
                    labelText: 'Middle Name',
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
                      return 'Required. Please enter your last name.';
                    }
                    return null;
                  },
                  controller: lnameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
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
                      return 'Required. Please enter your address.';
                    }
                    return null;
                  },
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
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
                      return 'Required. Please enter an email address.';
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
                DateTimeFormField(
                  dateTextStyle: inputTextSize,
                  decoration: const InputDecoration(
                    labelText: 'Birthdate',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onDateSelected: (DateTime value) {
                    bdate = value;
                  },
                ),
                const SizedBox(height: 12),
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
  }
}
