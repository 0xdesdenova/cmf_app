import 'package:flutter/material.dart';

// Utility Functions
import 'utility_functions.dart';

// Routes
import 'workout_detail.dart';

class GymDetail extends StatefulWidget {
  const GymDetail({Key? key, required this.gym}) : super(key: key);

  final Map gym;

  @override
  _GymDetailState createState() => _GymDetailState();
}

class _GymDetailState extends State<GymDetail> {
  String map =
      'https://maps.googleapis.com/maps/api/staticmap?center=15.7835%2C90.2308&zoom=17&size=600x400&key=AIzaSyBDErgqzZEzZR9_EG-4I6ht_4e-PNTZCi0';
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
                  widget.gym['name'],
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.favorite_border),
                ),
              ],
            ),
            Text(
              widget.gym['chain']['name'],
              style: const TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.gym['address'],
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              '📍 ${calculateDistance(latitude: widget.gym['latitude'], longitude: widget.gym['longitude'])}km away',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              '🕘 ${parseTime(widget.gym['open'])} - ${parseTime(widget.gym['close'])}',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              widget.gym['workouts'].length == 1
                  ? '⚡️ ${widget.gym['workouts'].length} Class'
                  : '⚡️ ${widget.gym['workouts'].length} Classes',
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
    for (var element in widget.gym['workouts']) {
      workoutList.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutDetail(
                  workout: element,
                  workouts: element['workouts'],
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
                              '🕘 ${parseDuration(element['duration'])}',
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
  Future confirmReservation(BuildContext context, Map element) async {
    return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                'Choose a time for ${element['name']}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: 75,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(
                        width: 3,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Text(
                      '10:30',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 20,
                      ),
                    )),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 10);
                },
                itemCount: 10,
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
                'Are you sure you want to reserve a spot for Q${element['price']}?',
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
                  onLongPress: () {
                    Navigator.pop(context);
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
      },
    ).then((value) => value ?? false
        ? ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Class Reserved')))
        : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            appBar(),
            buildDetails(),
            buildWorkouts(),
          ],
        ),
      ),
    );
  }
}
