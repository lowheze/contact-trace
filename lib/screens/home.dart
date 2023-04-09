import 'package:contact_trace_3b/constants/style_constants.dart';
import 'package:contact_trace_3b/screens/login.dart';
import 'package:contact_trace_3b/screens/register_client.dart';
import 'package:contact_trace_3b/screens/register_establishment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              alignment: Alignment.bottomCenter,
              opacity: 0.6,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Contact Trace',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'A mobile app for tracing contacts on MAD 2 class',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(
                height: 12.0,
              ),
              Text(
                'Please login or signup',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(
                height: 12.0,
              ),
              // Image.asset('assets/images/background.png'),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: roundShape,
                ),
                child: const Text('Login'),
              ),
              OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const RegisterClientScreen(),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  shape: roundShape,
                ),
                child: const Text('Sign Up as Client'),
              ),
              OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const RegisterEstablishmentScreen(),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  shape: roundShape,
                  backgroundColor: Colors.white38,
                ),
                child: const Text('Sign Up as Establishment'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
