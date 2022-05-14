import 'package:flutter/material.dart';
import 'dart:convert';

// Utility Functions
import 'utility_functions.dart';
import 'schedule_workout.dart';

// Modles
import 'user.dart';

// Packages
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class WorkoutDetail extends StatefulWidget {
  const WorkoutDetail({Key? key, required this.workout, this.workouts})
      : super(key: key);

  final int workout;
  final workouts;

  @override
  _WorkoutDetailState createState() => _WorkoutDetailState();
}

class _WorkoutDetailState extends State<WorkoutDetail> {
  // Variables
  Map workout = {};
  List passes = [];

  void getWorkout() {
    Uri uri = Uri.parse(
        'https://choosemyfitness-api.herokuapp.com/api/gyms/workouts/${widget.workout}/');

    http.get(uri).then((response) {
      setState(() {
        workout = json.decode(utf8.decode(response.bodyBytes));
      });
    });
  }

  // View Elements
  SliverAppBar appBar() {
    return SliverAppBar(
      expandedHeight: 200,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: FadeInImage.assetNetwork(
          placeholder: 'images/image.png',
          image: workout['type']['image'],
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  SliverPadding workoutDetails() {
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
                  workout['name'],
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    confirmReservation(context, workout);
                  },
                  child: Chip(
                    backgroundColor: Colors.grey[300],
                    label: const Text(
                      'Book Now',
                    ),
                  ),
                ),
              ],
            ),
            Text(
              workout['type']['name'],
              style: const TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: 18,
              ),
            ),
            Text(
              '@${workout['gym']['name']}',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'About',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              workout['description'],
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '📍 ${calculateDistance(latitude: workout['gym']['latitude'], longitude: workout['gym']['longitude'])}km away',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              '🕘 ${workout['duration']}m',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              workout['capacity'] == 1
                  ? '⚡️ ${workout['capacity']} Person'
                  : '⚡️ ${workout['capacity']} People',
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

  SliverPadding passHistory() {
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
                'Pass History',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: passes.isNotEmpty
                  ? ListView.separated(
                      padding: const EdgeInsets.only(left: 20),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
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
                                    passes[index]['workout']['gym']['name'],
                                    style: TextStyle(
                                        color: Colors.grey[100],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Text(
                                    passes[index]['workout']['name'],
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
                      itemCount: passes.length,
                    )
                  : const Center(
                      child: Text('You have not attended this class.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  SliverPadding similarWorkouts() {
    List<Widget> workoutList = [];
    workoutList.add(
      Text(
        'Similar Workouts',
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    widget.workouts.forEach((element) {
      workoutList.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutDetail(
                  workout: element['id'],
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
                                  fontWeight: FontWeight.w300),
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
    });
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          workoutList,
        ),
      ),
    );
  }

  // Lifecycle Methods
  @override
  void didChangeDependencies() {
    passes = Provider.of<UserData>(context)
        .user['passes']
        .where((element) => element['workout']['id'] == widget.workout)
        .toList();
    getWorkout();
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
    return Scaffold(
      body: Center(
        child: workout.isNotEmpty
            ? CustomScrollView(
                slivers: <Widget>[
                  appBar(),
                  workoutDetails(),
                  passHistory(),
                  widget.workouts != null
                      ? similarWorkouts()
                      : SliverToBoxAdapter(
                          child: Container(),
                        ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
