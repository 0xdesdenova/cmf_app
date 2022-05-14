import 'package:flutter/material.dart';
import 'dart:convert';

// Packages
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

// Models
import 'user.dart';

// Routes
import 'register.dart';
import 'navigation.dart';

// Utilities
import 'notification.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Variables
  bool loading = false;
  final storage = const FlutterSecureStorage();

  Map loginData = {
    'sent_token': false,
    'email': TextEditingController(),
    'token': TextEditingController(),
  };

  // API Calls
  void getToken() async {
    // Set Loading
    setState(() {
      loading = true;
    });

    Uri uri =
        Uri.parse('https://choosemyfitness-api.herokuapp.com/api/users/token/');

    var response = await http.post(
      uri,
      body: {
        'email': loginData['email'].text,
      },
    );

    // Remove loading.
    setState(() {
      loading = false;
    });

    if (response.statusCode == 201) {
      await showNotification(
        context: context,
        title: 'Token Generated',
        body:
            'We have created a single use token for you. Check your email. If it is not in your inbox, make sure you check your spam folder.',
      );
      setState(() {
        loginData['sent_token'] = true;
      });
    } else {
      await showNotification(
        context: context,
        title: 'Oops!',
        body:
            'We can\'t seem to find you. Make sure you have entered the email address you used when you created your account. If you have not created an account, follow the link below to register!',
      );
    }
  }

  void login() async {
    // Set Loading
    setState(() {
      loading = true;
    });

    Uri uri =
        Uri.parse('https://choosemyfitness-api.herokuapp.com/api/users/login/');

    var request = await http.post(
      uri,
      body: {
        'email': loginData['email'].text,
        'token': loginData['token'].text,
      },
    );

    // Remove Loading
    setState(() {
      loading = false;
    });

    if (request.statusCode == 202) {
      var response = json.decode(utf8.decode(request.bodyBytes));

      await storage.write(
          key: 'user_id', value: response['user']['id'].toString());
      await storage.write(key: 'jwt', value: response['jwt']);
      Provider.of<UserData>(context, listen: false).setUser(response['user']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CustomNavigationBar(),
        ),
      );
    } else {
      await showNotification(
        context: context,
        title: 'Oops!',
        body:
            'That token does not match the one we generated for you. Make sure you are using the last one we sent you!',
      );
    }
  }

  // View Elements
  PreferredSize loader() {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 4.0),
      child: loading ? const LinearProgressIndicator() : Container(),
    );
  }

  Center logo() {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 100, 0, 50),
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150),
          color: Colors.deepPurpleAccent,
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(150),
            child: Image.asset(
              'images/logo.png',
              width: 300,
            ),
          ),
        ),
      ),
    );
  }

  Padding title() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Text(
        'Log In',
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 40,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Padding input() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller:
            loginData['sent_token'] ? loginData['token'] : loginData['email'],
        keyboardType: loginData['sent_token']
            ? TextInputType.number
            : TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: loginData['sent_token'] ? 'Token' : 'Email',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.deepPurpleAccent,
            ),
          ),
        ),
      ),
    );
  }

  Padding button() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            if (!loading) {
              loginData['sent_token'] ? login() : getToken();
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.deepPurpleAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            loginData['sent_token'] ? 'Login' : 'Get Token',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          loader(),
          logo(),
          title(),
          input(),
          button(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Or register ',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Register(),
                    ),
                  );
                },
                child: const Text(
                  'here',
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
    );
  }
}
