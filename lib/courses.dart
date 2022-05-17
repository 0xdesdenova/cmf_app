import 'package:flutter/material.dart';
import 'dart:convert';

// Models
import 'user.dart';

// Packages
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// Routes
import 'course_detail.dart';
import 'video.dart';

class CourseList extends StatefulWidget {
  const CourseList({Key? key}) : super(key: key);

  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  List levels = [
    'Begginer',
    'Intermediate',
    'Advanced',
  ];
  List courses = [];

  // API Calls
  void getCourses() {
    Uri uri = Uri.parse(
        'https://choosemyfitness-api.herokuapp.com/api/virtual_workouts/courses/');

    http.get(uri).then((response) {
      setState(() {
        courses = json.decode(utf8.decode(response.bodyBytes));
      });
    });
  }

  // View Elements
  SliverAppBar appBar() {
    return SliverAppBar(
      centerTitle: true,
      expandedHeight: 200,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.tune),
        onPressed: () {
          Scaffold.of(context).openEndDrawer();
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Image.asset(
          'images/video_workout.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  SliverPadding buildCourses() {
    List<Widget> courseList = [];
    courseList.add(
      Text(
        'Workouts',
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    for (var element in courses) {
      courseList.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetail(
                  course: element,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Stack(
                alignment: Alignment.centerRight,
                children: <Widget>[
                  FadeInImage.assetNetwork(
                    placeholder: 'images/image.png',
                    image: element['type']['image'],
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  Column(
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
                          Text(
                            element['type']['name'],
                            style: const TextStyle(
                              color: Colors.deepPurpleAccent,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '📺 ${element['workouts'].length} Routines',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300),
                            ),
                            Text(
                              '🔥 ${levels[element['level']]}',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300),
                            ),
                            Text(
                              '🕘 ${courseDuration(element['workouts'])} minutes',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          courseList,
        ),
      ),
    );
  }

  // View Utility Methods
  num courseDuration(List course) {
    num totalTime = 0;
    for (var element in course) {
      totalTime += element['duration'];
    }
    return totalTime;
  }

  // View Lifecycle Methods
  @override
  void didChangeDependencies() {
    getCourses();
    super.didChangeDependencies();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: courses.isNotEmpty
          ? CustomScrollView(
              slivers: <Widget>[
                appBar(),
                const RecurringSessions(),
                buildCourses(),
              ],
            )
          : const CircularProgressIndicator(),
    );
  }
}

// View Widgets
class RecurringSessions extends StatefulWidget {
  const RecurringSessions({
    Key? key,
  }) : super(key: key);

  @override
  State<RecurringSessions> createState() => _RecurringSessionsState();
}

class _RecurringSessionsState extends State<RecurringSessions> {
  // Variables
  List sessions = [];
  @override
  void didChangeDependencies() {
    sessions = Provider.of<UserData>(context).user['sessions'].toSet().toList();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                'Repeat',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: sessions.isNotEmpty
                  ? ListView.separated(
                      padding: const EdgeInsets.only(left: 20),
                      itemCount: sessions.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Video(
                                  workout: sessions[index]['virtual_workout'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.deepPurpleAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: 250,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    sessions[index]['virtual_workout']['course']
                                        ['name'],
                                    style: TextStyle(
                                        color: Colors.grey[100],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Text(
                                    sessions[index]['virtual_workout']['name'],
                                    style: TextStyle(
                                      color: Colors.grey[100],
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 20,
                        );
                      },
                    )
                  : const Center(
                      child: Text('You have not started any courses'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
