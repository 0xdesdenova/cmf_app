import 'package:flutter/material.dart';
import 'dart:convert';

// Utility Functions
import 'schedule_workout.dart';

// Modles
import 'user.dart';

// Packages
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// Routes
import 'workout_detail.dart';

class WorkoutList extends StatefulWidget {
  const WorkoutList({Key? key}) : super(key: key);

  @override
  _WorkoutListState createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutList> {
  // Variables
  Map filters = {
    'level': 'Begginer',
  };
  List workouts = [];
  List recentWorkouts = [];

  // API Calls
  void getWorkouts() {
    Uri uri = Uri.parse(
        'https://choosemyfitness-api.herokuapp.com/api/gyms/workouts/');

    http.get(uri).then((response) {
      setState(() {
        workouts = json.decode(utf8.decode(response.bodyBytes));
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
          showFilters();
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Image.asset(
          'images/workout.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  SliverPadding buildPasses() {
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
                'Recent Workouts',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: recentWorkouts.isNotEmpty
                  ? ListView.separated(
                      padding: const EdgeInsets.only(left: 20),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkoutDetail(
                                  workout: recentWorkouts[index]['workout']
                                      ['id'],
                                  workouts: workouts,
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
                                    recentWorkouts[index]['workout']['type']
                                        ['name'],
                                    style: TextStyle(
                                        color: Colors.grey[100],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Text(
                                    recentWorkouts[index]['workout']['name'],
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
                      itemCount: recentWorkouts.length,
                    )
                  : const Center(
                      child: Text('You have not worked out recently'),
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
    for (var element in workouts) {
      workoutList.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutDetail(
                  workout: element['id'],
                  workouts: workouts,
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

  // View Methods
  void orderRecents() {
    Map allPassess = {};
    List userPasses = Provider.of<UserData>(context).user['passes'];
    if (userPasses.isNotEmpty) {
      for (var element in userPasses.reversed) {
        if (allPassess.containsKey(element['workout']['id'])) {
          allPassess[element['workout']['id']].add(element);
        } else {
          allPassess[element['workout']['id']] = [element];
        }
      }
      allPassess.forEach((key, value) {
        recentWorkouts.add(value[0]);
      });
    }
  }

  void showFilters() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          List filters = [
            {
              'name': 'flexibility',
              'label': 'Flexibility',
              'value': false,
            },
            {
              'name': 'strength',
              'label': 'Strength Training',
              'value': false,
            },
            {
              'name': 'mindfulness',
              'label': 'Mindfulness',
              'value': false,
            },
            {
              'name': 'aerobics',
              'label': 'Aerobics',
              'value': false,
            },
            {
              'name': 'premium',
              'label': 'Premium Content',
              'value': false,
            },
          ];

          List<Widget> createFilters() {
            List<Widget> filterList = [];
            for (var element in filters) {
              filterList.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      element['label'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Switch(
                    value: element['value'],
                    onChanged: (value) {
                      setState(() {
                        element['value'] = !element['value'];
                      });
                    },
                  )
                ],
              ));
            }
            return filterList;
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(150),
                    child: Image.asset(
                      'images/filter.png',
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Text(
                  'Select Filters to Apply',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: createFilters(),
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Filter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  // Lifecycle Methods
  @override
  void didChangeDependencies() {
    orderRecents();
    getWorkouts();
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
      child: workouts.isNotEmpty
          ? CustomScrollView(
              slivers: <Widget>[
                appBar(),
                buildPasses(),
                buildWorkouts(),
              ],
            )
          : const CircularProgressIndicator(),
    );
  }
}
