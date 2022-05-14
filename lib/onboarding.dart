import 'package:flutter/material.dart';

// Routes
import 'login.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentPage = 0;

  List<Widget> createOnboardingSlides() {
    List<Map> slideInfo = [
      {
        'image': 'images/track.png',
        'title': 'Get your Pump On',
        'caption': 'Get your routines in a single place',
      },
      {
        'image': 'images/customize.png',
        'title': 'You do You',
        'caption': 'Customize your workouts from dozens of training videos',
      },
      {
        'image': 'images/stats.png',
        'title': 'Automatic Tracking',
        'caption': 'Get insights into your progress in real time',
      },
    ];
    List<Widget> slides = [];
    for (var element in slideInfo) {
      slides.add(Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(150),
              child: Image.asset(
                element['image'],
                height: 300,
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 60, 50, 15),
              child: Text(
                element['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 15, 50, 0),
              child: Text(
                element['caption'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ));
    }
    return slides;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              controller: PageController(initialPage: 0),
              onPageChanged: (page) {
                setState(() {
                  currentPage = page;
                });
              },
              children: createOnboardingSlides(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  currentPage == 0
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: Colors.grey[700],
                ),
                Icon(
                  currentPage == 1
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: Colors.grey[700],
                ),
                Icon(
                  currentPage == 2
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: Colors.grey[700],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 20,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: RaisedButton(
                color: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                child: const Text(
                  'Start',
                  style: TextStyle(
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
