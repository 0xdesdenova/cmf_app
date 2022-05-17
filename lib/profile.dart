import 'package:flutter/material.dart';
import 'dart:math';

// Models
import 'user.dart';

// Packages
import 'package:provider/provider.dart';

// Utility Functions
import 'manage_subscription.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with WidgetsBindingObserver {
  // Variables
  List<Color> levelColors = [
    Colors.amber,
    Colors.orangeAccent,
    Colors.green,
    Colors.redAccent,
    Colors.indigoAccent,
    Colors.deepPurpleAccent,
  ];

  Map user = {};
  List<Map> exerciseTypeProgress = [];

  // View Elements
  SliverAppBar appBar() {
    return SliverAppBar(
      expandedHeight: 300,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        background: Image.asset(
          'images/profile.png',
          fit: BoxFit.cover,
        ),
        title: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            '${user['first_name']} ${user['last_name']}',
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
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
                      children: [
                        Text(
                          '${streak()} 🔥',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
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
                      children: [
                        Text(
                          '${totalSessions()} 💪',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          'total sessions',
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
            GestureDetector(
              onTap: () {
                manageSubscription(context: context, user: user);
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  user['subscription_level'] == 0
                      ? '⚡️ Go Pro to unlock all features for \$7.99/month.'
                      : '⚡️  Way to go! Manage your active pro subscription here.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverPadding buildExerciseProgress() {
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
              children: [
                FadeInImage.assetNetwork(
                  placeholder: 'images/image.png',
                  image: element['image'],
                  fit: BoxFit.fill,
                ),
                Expanded(
                  child: Column(
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
                        '${element['experience']}xp',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
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
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 20),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          exerciseProgressList,
        ),
      ),
    );
  }

  // View Methods
  String streak() {
    bool missedDay = false;
    DateTime date = DateTime.now();
    int days = 0;

    List attendances =
        user['entries'].map((element) => element['timestamp']).toList() +
            user['passes'].map((element) => element['scheduled']).toList() +
            user['sessions'].map((element) => element['timestamp']).toList();

    while (!missedDay) {
      attendances.firstWhere(
          (element) => element.split('T')[0] == date.toString().split(' ')[0],
          orElse: () => missedDay = true);

      if (!missedDay) {
        days++;
        date = date.add(const Duration(days: -1));
      }
    }
    return '$days';
  }

  int totalSessions() {
    return user['entries'].length +
        user['passes'].length +
        user['sessions'].length;
  }

  void generateTypeProgress() {
    Map allEntries = {};
    exerciseTypeProgress = [];
    for (var element in user['passes'].reversed) {
      if (allEntries.containsKey(element['workout']['type']['id'])) {
        allEntries[element['workout']['type']['id']]['experience'] += 10;
      } else {
        allEntries[element['workout']['type']['id']] =
            element['workout']['type'];
        allEntries[element['workout']['type']['id']]['experience'] = 10;
      }
    }
    for (var element in user['sessions'].reversed) {
      if (allEntries
          .containsKey(element['virtual_workout']['course']['type']['id'])) {
        allEntries[element['virtual_workout']['course']['type']['id']]
            ['experience'] += 5;
      } else {
        allEntries[element['virtual_workout']['course']['type']['id']] =
            element['virtual_workout']['course']['type'];
        allEntries[element['virtual_workout']['course']['type']['id']]
            ['experience'] = 5;
      }
    }
    allEntries.forEach((key, value) {
      exerciseTypeProgress.add(
        {
          'name': value['name'],
          'experience': value['experience'],
          'image': value['image'],
        },
      );
    });
  }

  // Lifecycle Methods
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (checkoutId != '') {
        await addCreditCard(context: context, userId: user['id'])
            .then((value) => value ? Navigator.pop(context, true) : null);
      }
    }
  }

  @override
  initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    user = Provider.of<UserData>(context).user;
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
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
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
