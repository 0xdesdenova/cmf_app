import 'package:flutter/material.dart';
import 'dart:math';

// Models
import 'user.dart';

// Packages
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Variables
  int subscription = 0;
  List entries = [];
  List passes = [];
  List sessions = [];
  List<Map> exerciseTypeProgress = [];

  List<Color> levelColors = [
    Colors.amber,
    Colors.orangeAccent,
    Colors.green,
    Colors.redAccent,
    Colors.indigoAccent,
    Colors.deepPurpleAccent,
  ];

  // API Calls
  Future updateSubscription({required String subscriptionLevel}) async {
    String userId =
        Provider.of<UserData>(context, listen: false).user['id'].toString();
    Uri uri = Uri.parse(
        'https://choosemyfitness-api.herokuapp.com/api/users/$userId/');

    var response = await http.patch(uri, body: {
      'subscription_level': subscriptionLevel,
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

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
                manageSubscription();
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  subscription == 0
                      ? '⚡️ Go Pro to unlock all features for \$7.99/month.'
                      : '⚡️  Way to go! Manage your active pro subscription.',
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
    return SliverList(
      delegate: SliverChildListDelegate(
        exerciseProgressList,
      ),
    );
  }

  void manageSubscription() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Credit Card',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const ListTile(
                leading: Icon(Icons.credit_card),
                title: Text('Visa ending in 3005'),
                subtitle: Text('Expires 02/23'),
                trailing: Icon(Icons.clear),
              ),
              const Text(
                'Subscription Level',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                'Hold down to subscribe',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              Column(
                children: [
                  ListTile(
                    onLongPress: () async {
                      bool success =
                          await updateSubscription(subscriptionLevel: '1');
                      if (success) {
                        Navigator.pop(context, true);
                      }
                    },
                    title: const Text('Ultimate'),
                    subtitle: const Text('Voltio, Orange Theory'),
                    trailing: subscription == 1
                        ? const Icon(Icons.radio_button_on)
                        : const Icon(Icons.radio_button_off),
                  ),
                  ListTile(
                    onLongPress: () async {
                      bool success =
                          await updateSubscription(subscriptionLevel: '2');
                      if (success) {
                        Navigator.pop(context, true);
                      }
                    },
                    title: const Text('Premium'),
                    subtitle: const Text('Fitness One, World Gym'),
                    trailing: subscription == 2
                        ? const Icon(Icons.radio_button_on)
                        : const Icon(Icons.radio_button_off),
                  ),
                  ListTile(
                    onLongPress: () async {
                      bool success =
                          await updateSubscription(subscriptionLevel: '3');
                      if (success) {
                        Navigator.pop(context, true);
                      }
                    },
                    title: const Text('Basic'),
                    subtitle: const Text('Sporta, Exerzone'),
                    trailing: subscription == 3
                        ? const Icon(Icons.radio_button_on)
                        : const Icon(Icons.radio_button_off),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ).then((value) => value ?? false
        ? ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Subscription Updated')))
        : null);
  }

  // View Methods
  String streak() {
    bool missedDay = false;
    DateTime date = DateTime.now();
    int days = 0;

    List attendances = entries.map((element) => element['timestamp']).toList() +
        passes.map((element) => element['scheduled']).toList() +
        sessions.map((element) => element['timestamp']).toList();

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
    return entries.length + passes.length + sessions.length;
  }

  void generateTypeProgress() {
    Map allEntries = {};
    for (var element in passes.reversed) {
      if (allEntries.containsKey(element['workout']['type']['id'])) {
        allEntries[element['workout']['type']['id']]['experience'] += 10;
      } else {
        allEntries[element['workout']['type']['id']] =
            element['workout']['type'];
        allEntries[element['workout']['type']['id']]['experience'] = 10;
      }
    }
    for (var element in sessions.reversed) {
      if (allEntries.containsKey(element['virtual_workout']['type'])) {
        allEntries[element['virtual_workout']['type']]['experience'] += 5;
      } else {
        allEntries[element['virtual_workout']['type']] =
            element['virtual_workout']['type'];
        allEntries[element['virtual_workout']['type']]['experience'] = 5;
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
  void didChangeDependencies() {
    subscription =
        Provider.of<UserData>(context).user['subscription_level'] ?? 0;
    entries = Provider.of<UserData>(context).user['entries'];
    passes = Provider.of<UserData>(context).user['passes'];
    sessions = Provider.of<UserData>(context).user['sessions'];
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
