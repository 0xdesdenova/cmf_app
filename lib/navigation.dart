import 'package:flutter/material.dart';

// Routes
import 'gyms.dart';
import 'workouts.dart';
import 'courses.dart';
import 'profile.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  // Variables
  int page = 0;
  List pages = [
    const GymList(),
    const WorkoutList(),
    const CourseList(),
    const Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: page,
        elevation: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            page = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.fitness_center),
          ),
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.sports_gymnastics),
          ),
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.live_tv),
          ),
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
    );
  }
}
