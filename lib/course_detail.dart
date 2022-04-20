import 'package:flutter/material.dart';

// Routes
import 'video.dart';

class CourseDetail extends StatefulWidget {
  @override
  _CourseDetailState createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  Map course = {
    'type': 'Strength Trianing 💪',
    'name': 'Strength 201',
    'description': 'Build those tricky to get to muscles, on the spot.',
    'image': 'images/strength.png',
    'routines': [
      {
        'order': 1,
        'name': 'Push Ups',
        'description': 'Classic push ups.',
        'repetitions': '10',
        'time': 10,
      },
      {
        'order': 2,
        'name': 'Pull Ups',
        'description': 'Lift your body weight.',
        'repetitions': '15',
        'time': 5,
      },
      {
        'order': 3,
        'name': 'Curl Ups',
        'description': 'Abs: chiseled.',
        'repetitions': '25',
        'time': 20,
      },
      {
        'order': 4,
        'name': 'Leg Ups',
        'description': 'Feel the burn.',
        'repetitions': '20',
        'time': 10,
      },
      {
        'order': 5,
        'name': 'Dips',
        'description': 'Don\'t forget them TRI CEPS.',
        'repetitions': '30',
        'time': 10,
      },
    ],
    'level': 'Intermediate',
    'time': 30,
  };

  List<Widget> buildRoutines() {
    List<Widget> routineList = [];
    course['routines'].forEach((element) {
      routineList.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Video()));
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            height: 100,
            child: Row(
              children: <Widget>[
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      element['order'].toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              element['name'],
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          element['description'],
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '🔥 ${element['repetitions']} reps',
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '🕘 ${element['time']} minutes',
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
    return routineList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 400,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                background: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(150),
                    child: Image.asset(
                      course['image'],
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        course['name'],
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        course['type'],
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                titlePadding: EdgeInsets.zero,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  buildRoutines(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
