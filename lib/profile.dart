import 'package:flutter/material.dart';
import 'dart:math';

// Models
import 'user.dart';

// Packages
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Variables
  List passes = [];
  List sessions = [];
  List<Map> exerciseTypeProgress = [
    {
      'name': 'Flexibility',
      'icon': '🤸',
      'experience': 0,
      'image': 'images/yoga.png',
    },
    {
      'name': 'Aerobics',
      'icon': '🚴',
      'experience': 10,
      'image': 'images/cardio.png',
    },
    {
      'name': 'Strength Trianing',
      'icon': '💪',
      'experience': 5,
      'image': 'images/core.png',
    },
    {
      'name': 'Mindfulness',
      'icon': '🧘‍♂️',
      'experience': 300,
      'image': 'images/mindfulness.png',
    },
  ];

  List<Color> levelColors = [
    Colors.amber,
    Colors.orangeAccent,
    Colors.green,
    Colors.redAccent,
    Colors.indigoAccent,
    Colors.deepPurpleAccent,
  ];

  // View Elements
  SliverAppBar appBar() {
    return SliverAppBar(
      expandedHeight: 400,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(150),
            child: Image.asset(
              'images/profile.png',
              height: 300,
              width: 300,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Enrique Descamps',
              style: TextStyle(
                color: Colors.grey[900],
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Level: Pro',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
          ],
        ),
        titlePadding: EdgeInsets.zero,
      ),
    );
  }

  SliverPadding buildStats() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '3 🔥',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'day streak',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '4 🕘',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'hours/week',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '🔥⚡️ Go Pro to unlock all features for \$7.99/month.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverList buildExerciseProgress() {
    List<Widget> exerciseProgressList = [];
    for (var element in exerciseTypeProgress) {
      exerciseProgressList.add(
        Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  element['image'],
                  fit: BoxFit.fill,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${element['name']}',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${element['experience']} sessions this week.',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: log(element['experience']) < 0
                          ? 0.toDouble()
                          : (log(element['experience']) -
                                  log(element['experience']).floor())
                              .toDouble(),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        levelColors[log(element['experience']) < 0
                            ? 0
                            : log(element['experience']).floor() %
                                levelColors.length],
                      ),
                    ),
                    Text(
                      '${log(element['experience']) < 0 ? 0 : log(element['experience']).floor()}',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildListDelegate(
        exerciseProgressList,
      ),
    );
  }

  // View Methods
  void generateTypeProgress() {
    Map allEntries = {};
    Provider.of<UserData>(context).user['passes'].reversed.forEach((element) {
      if (allEntries.containsKey(element['workout']['type']['id'])) {
        allEntries[element['workout']['type']['id']]['points'] += 10;
      } else {
        allEntries[element['workout']['type']['id']] =
            element['workout']['type'];
        allEntries[element['workout']['type']['id']]['points'] = 10;
      }
    });
    Provider.of<UserData>(context).user['sessions'].reversed.forEach((element) {
      if (allEntries.containsKey(element['virtual_workout']['type'])) {
        allEntries[element['virtual_workout']['type']]['points'] += 5;
      } else {
        allEntries[element['virtual_workout']['type']] =
            element['virtual_workout']['type'];
        allEntries[element['virtual_workout']['type']]['points'] = 5;
      }
    });
    print(allEntries);
  }

  // Lifecycle Methods
  @override
  void didChangeDependencies() {
    generateTypeProgress();
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
      child: CustomScrollView(
        slivers: <Widget>[
          appBar(),
          buildStats(),
          buildExerciseProgress(),
        ],
      ),
    );
  }
}
