import 'package:flutter/material.dart';

import 'dart:math';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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

  List<Widget> buildExerciseProgress() {
    List<Widget> exerciseProgressList = [];
    exerciseTypeProgress.forEach((element) {
      exerciseProgressList.add(
        Container(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                      style: TextStyle(
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
    });
    return exerciseProgressList;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
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
          ),
          SliverPadding(
            padding: EdgeInsets.only(top: 20),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '🔥⚡️ Go Pro to unlock all features for \$7.99/month.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              buildExerciseProgress(),
            ),
          ),
        ],
      ),
    );
  }
}
