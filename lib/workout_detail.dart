import 'package:flutter/material.dart';

// Utility Functions
import 'utility_functions.dart';

// Routes

class WorkoutDetail extends StatefulWidget {
  const WorkoutDetail({Key? key, required this.workout, this.workouts})
      : super(key: key);

  final Map workout;
  final workouts;

  @override
  _WorkoutDetailState createState() => _WorkoutDetailState();
}

class _WorkoutDetailState extends State<WorkoutDetail> {
  // Variables
  List passes = [];
  // View Elements
  SliverAppBar appBar() {
    return SliverAppBar(
      expandedHeight: 200,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          widget.workout['type']['image'],
          fit: BoxFit.cover,
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
                  widget.workout['name'],
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    confirmReservation(context, widget.workout);
                  },
                  child: const Text('Book Now'),
                ),
              ],
            ),
            Text(
              widget.workout['type']['name'],
              style: const TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: 18,
              ),
            ),
            Text(
              '@${widget.workout['gym']['name']}',
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
              widget.workout['description'],
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '📍 ${calculateDistance(latitude: widget.workout['gym']['latitude'], longitude: widget.workout['gym']['longitude'])}km away',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              '🕘 ${parseTime(widget.workout['duration'])}',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              widget.workout['capacity'] == 1
                  ? '⚡️ ${widget.workout['capacity']} Person'
                  : '⚡️ ${widget.workout['capacity']} People',
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
                  workout: element,
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
                    Navigator.pop(context, true);
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
            workoutDetails(),
            passHistory(),
            widget.workouts != null
                ? similarWorkouts()
                : SliverToBoxAdapter(
                    child: Container(),
                  ),
          ],
        ),
      ),
    );
  }
}
