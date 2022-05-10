import 'package:flutter/material.dart';
import 'dart:convert';

// Utility Functions
import 'utility_functions.dart';

// Models
import 'user.dart';

// Packages
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
  PageController controller = PageController();
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

  Future getPass({required int workout, required String scheduled}) async {
    Uri uri =
        Uri.parse('https://choosemyfitness-api.herokuapp.com/api/gyms/passes/');

    var response = await http.post(uri, body: {
      'workout': workout.toString(),
      'user':
          Provider.of<UserData>(context, listen: false).user['id'].toString(),
      'scheduled': scheduled,
    });

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
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
                    child: Image.network(
                      element['type']['image'],
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

  // View Methods
  List buildSchedule({required Map workout, required int dateOffset}) {
    int weekday = DateTime.now().add(Duration(days: dateOffset)).weekday;
    return workout['schedule']
        .where((element) => element['day'] == weekday)
        .toList();
  }

  Future confirmReservation(BuildContext context, Map workout) async {
    return await showModalBottomSheet(
      context: context,
      builder: (context) {
        List days = [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thurday',
          'Friday',
          'Saturday',
          'Sunday',
        ];
        List months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sept',
          'Oct',
          'Nov',
          'Dec',
        ];
        int dateOffset = 0;
        int selectedTimeSlot = 0;

        DateTime now = DateTime.now();
        DateTime selectedDate = now.add(Duration(days: dateOffset));
        List schedule = buildSchedule(workout: workout, dateOffset: dateOffset);

        return StatefulBuilder(builder: (context, setModalState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Choose a date for ${workout['name']}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                height: 75,
                child: PageView.builder(
                  controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (newIndex) {
                    setModalState(() {
                      selectedTimeSlot = 0;
                      selectedDate = now.add(Duration(days: dateOffset));
                      schedule =
                          buildSchedule(workout: workout, dateOffset: newIndex);
                    });
                  },
                  itemBuilder: (context, index) {
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (dateOffset > 0) {
                                dateOffset--;
                                controller.animateToPage(
                                  dateOffset,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              }
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: dateOffset > 0
                                  ? Colors.black
                                  : Colors.grey[200],
                            ),
                          ),
                          Text(
                            '${days[selectedDate.weekday - 1]} ${months[selectedDate.month - 1]} ${selectedDate.day}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (dateOffset < 7) {
                                dateOffset++;
                                controller.animateToPage(
                                  dateOffset,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              }
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: dateOffset < 7
                                  ? Colors.black
                                  : Colors.grey[200],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Schedule',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Choose a time for ${workout['name']}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                height: 75,
                child: schedule.isNotEmpty
                    ? ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedTimeSlot = index;
                              });
                            },
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                color: selectedTimeSlot == index
                                    ? Colors.grey[200]
                                    : Colors.white,
                                border: Border.all(
                                  width: 3,
                                  color: selectedTimeSlot == index
                                      ? Colors.grey
                                      : Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  parseTime(schedule[index]['time']),
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(width: 10);
                        },
                        itemCount: schedule.length,
                      )
                    : const Center(
                        child: Text('No time slots are available'),
                      ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Confirm Payment',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Are you sure you want to reserve a spot for Q${workout['price']}?',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () {},
                    onLongPress: () async {
                      // Build time based on selected date and time slot
                      List time = schedule[selectedTimeSlot]['time'].split(':');
                      String scheduled = DateTime(now.year, now.month, now.day,
                              int.parse(time[0]), int.parse(time[1]))
                          .add(Duration(days: dateOffset))
                          .toString();

                      bool success = await getPass(
                          workout: workout['id'], scheduled: scheduled);
                      if (success) {
                        Navigator.pop(context, true);
                      }
                    },
                    color: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Hold Down to Reserve',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
      },
    ).then((value) => value ?? false
        ? ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Class Reserved')))
        : null);
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
