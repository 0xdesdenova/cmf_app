import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Models
import 'user.dart';

// Packages
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Routes
import 'navigation.dart';
import 'onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Variables
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    String? userId = await storage.read(key: 'user_id');

    if (userId != null) {
      bool userExists =
          await Provider.of<UserData>(context, listen: false).getUser();
      if (userExists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CustomNavigationBar(),
          ),
        );
      } else {
        await Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Onboarding()));
        });
      }
    } else {
      await Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Onboarding()));
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Center(
        child: Image.asset('images/logo.png'),
      ),
    );
  }
}
