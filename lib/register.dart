import 'package:flutter/material.dart';
import 'dart:convert';

// Packages
import 'package:http/http.dart' as http;

// Utilities
import 'notification.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Variables
  bool loading = false;
  Map registerData = {
    'accepted_terms': false,
    'email': TextEditingController(),
    'first_name': TextEditingController(),
    'last_name': TextEditingController(),
  };

  // API Calls
  void register() async {
    // Set Loading
    setState(() {
      loading = true;
    });

    Uri uri = Uri.parse('https://choosemyfitness-api.herokuapp.com/api/users/');

    var response = await http.post(
      uri,
      body: {
        'email': registerData['email'].text,
        'first_name': registerData['first_name'].text,
        'last_name': registerData['last_name'].text,
      },
    );

    // Remove loading.
    setState(() {
      loading = false;
    });

    if (response.statusCode == 201) {
      await showNotification(
        context: context,
        title: 'Success!',
        body: 'You have created an account. Now, log in to continue.',
      );
      Navigator.pop(context);
    } else {
      print(response.body);
      await showNotification(
        context: context,
        title: 'Oops!',
        body:
            'There was an error creating an account. Make sure you have not used this email to sing up already.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PreferredSize(
            preferredSize: const Size(double.infinity, 4.0),
            child: loading ? const LinearProgressIndicator() : Container(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              'Register',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
            child: Text(
              'In order to start, wee need to know a little bit about you.',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: registerData['email'],
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextField(
                    controller: registerData['first_name'],
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextField(
                    controller: registerData['last_name'],
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          registerData['accepted_terms'] =
                              !registerData['accepted_terms'];
                        });
                      },
                      child: Icon(
                        registerData['accepted_terms']
                            ? Icons.radio_button_on
                            : Icons.radio_button_off,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'I agree to the ',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'terms and conditions',
                            style: TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          '.',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: RaisedButton(
                color: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  register();
                },
                child: const Text(
                  'Create Account',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
