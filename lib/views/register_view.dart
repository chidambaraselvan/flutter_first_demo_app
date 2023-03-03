import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  children: [
                    TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Enter your Email here',
                      ),
                    ),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: 'Enter your Password here',
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                        child: TextButton(
                            onPressed: () async {
                              final email = _email.text;
                              final password = _password.text;
                              try {
                                await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  print('Weak password');
                                } else if (e.code == 'email-already-in-use') {
                                  print('Already registered');
                                } else if (e.code == 'invalid-email') {
                                  print('invalid email');
                                }
                              }
                              
                            },
                            child: const Text('Register')),
                      ),
                    )
                  ],
                );
              default:
                return const Text('Loading...');
            }
          },
        ),
      ),
    );
  }
}