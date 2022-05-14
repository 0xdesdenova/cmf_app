import 'package:flutter/material.dart';
import 'dart:convert';

// Utility Functions
import 'utility_functions.dart';
import 'schedule_workout.dart';

// Packages
import 'package:http/http.dart' as http;

// Routes
import 'workout_detail.dart';

class GymDetail extends StatefulWidget {
  const GymDetail({Key? key, required this.gym}) : super(key: key);

  final int gym;

  @override
  _GymDetailState createState() => _GymDetailState();
}

class _GymDetailState extends State<GymDetail> {
  // Variables
  Map gym = {};
  String map =
      'https://maps.googleapis.com/maps/api/staticmap?center=15.7835%2C90.2308&zoom=17&size=600x400&key=AIzaSyBDErgqzZEzZR9_EG-4I6ht_4e-PNTZCi0';

  // API Calls
  void getGym() {
    Uri uri = Uri.parse(
        'https://choosemyfitness-api.herokuapp.com/api/gyms/${widget.gym}/');

    http.get(uri).then((response) {
      setState(() {
        gym = json.decode(utf8.decode(response.bodyBytes));
      });
    });
  }

  // View Elements
  SliverAppBar appBar() {
    return SliverAppBar(
      expandedHeight: 200,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          'images/map.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  SliverPadding buildDetails() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  gym['name'],
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(gym['chain']['image']),
                ),
              ],
            ),
            Text(
              gym['chain']['name'],
              style: const TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              gym['address'],
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              '📍 ${calculateDistance(latitude: gym['latitude'], longitude: gym['longitude'])}km away',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              '🕘 ${parseTime(gym['open'])} - ${parseTime(gym['close'])}',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              gym['workouts'].length == 1
                  ? '⚡️ ${gym['workouts'].length} Class'
                  : '⚡️ ${gym['workouts'].length} Classes',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverPadding buildWorkouts() {
    List<Widget> workoutList = [];
    workoutList.add(
      Text(
        'Workouts',
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    for (var element in gym['workouts']) {
      workoutList.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutDetail(
                  workout: element['id'],
                  workouts: gym['workouts'],
                ),
              ),
            );
          },
          onLongPress: () {
            confirmReservation(context, element);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'images/image.png',
                      image: element['type']['image'],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        element['description'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '💵 Q${element['price']}',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '🧍 ${element['capacity']} people',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '🕘 ${element['duration']}m',
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
                ),
              ],
            ),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          workoutList,
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    getGym();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: gym.isNotEmpty
            ? CustomScrollView(
                slivers: <Widget>[
                  appBar(),
                  buildDetails(),
                  buildWorkouts(),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
