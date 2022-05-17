import 'package:flutter/material.dart';

// Utility Functions
import 'utility_functions.dart';

// Models
import 'user.dart';

// Packages
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// Variables
PageController controller = PageController();
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

// API Calls
Future getPass(
    {required BuildContext context,
    required int workout,
    required String scheduled}) async {
  Uri uri =
      Uri.parse('https://choosemyfitness-api.herokuapp.com/api/gyms/passes/');

  var response = await http.post(uri, body: {
    'workout': workout.toString(),
    'user': Provider.of<UserData>(context, listen: false).user['id'].toString(),
    'scheduled': scheduled,
  });

  if (response.statusCode == 201) {
    Provider.of<UserData>(context, listen: false).updateUser();
    return true;
  } else {
    return false;
  }
}

// View Methods
List buildSchedule({required Map workout, required DateTime selectedDate}) {
  int weekday = selectedDate.weekday;
  List schedule = workout['schedule']
      .where((element) => element['day'] == weekday)
      .toList();

  for (var element in List.from(schedule)) {
    int reservations = 0;
    String time =
        '${selectedDate.toString().split(' ')[0]}T${element['time']}Z';
    workout['passes'].forEach((element) {
      if (element['scheduled'] == time) {
        reservations++;
      }
    });
    if (reservations >= workout['capacity']) {
      schedule.remove(element);
    }
  }

  return schedule;
}

Future confirmReservation(BuildContext context, Map workout) async {
  return await showModalBottomSheet(
    context: context,
    builder: (context) {
      DateTime now = DateTime.now();
      int dateOffset = 0;

      // TODO: Consider packaging.
      int selectedTimeSlot = 0;
      DateTime selectedDate = now.add(Duration(days: dateOffset));
      List schedule =
          buildSchedule(workout: workout, selectedDate: selectedDate);

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
                  // TODO: Consider packaging.
                  setModalState(() {
                    selectedTimeSlot = 0;
                    selectedDate = now.add(Duration(days: dateOffset));
                    schedule = buildSchedule(
                        workout: workout, selectedDate: selectedDate);
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
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
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
                                  color: selectedTimeSlot == index
                                      ? Colors.black
                                      : Colors.grey,
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
                      context: context,
                      workout: workout['id'],
                      scheduled: scheduled,
                    );
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
