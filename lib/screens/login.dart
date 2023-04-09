import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_trace_3b/constants/style_constants.dart';
import 'package:contact_trace_3b/screens/client.dart';
import 'package:contact_trace_3b/screens/establishment.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    const inputTextSize = TextStyle(
      fontSize: 16,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign In',
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
                const Text('Sign in your account:'),
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
                ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    shape: roundShape,
                  ),
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    //login
    if (_formkey.currentState!.validate()) {
      EasyLoading.show(status: 'Processing...');
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((userCredential) async {
        //fetch from the firestore
        String collectionPath = 'users';
        String userId = userCredential.user!.uid;
        final docSnapshot = await FirebaseFirestore.instance
            .collection(collectionPath)
            .doc(userId)
            .get();
        dynamic data = docSnapshot.data();
        Widget landingScreen;
        if (data['type'] == 'client') {
          landingScreen = ClientScreen(UserId: userId);
        } else{
          landingScreen = EstablishmentScreen(UserId: userId);
        }
        EasyLoading.dismiss();
        //choose if client or establishment
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => landingScreen));
      }).catchError((err) {
        print(err);
        EasyLoading.showError('Invalid email and/or password.');
      });
    }
  }
}
