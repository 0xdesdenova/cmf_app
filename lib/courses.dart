import 'package:flutter/material.dart';

// Routes
import 'course_detail.dart';
import 'profile.dart';

class CourseList extends StatefulWidget {
  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  Map filters = {
    'level': 'Begginer',
  };
  List courses = [
    {
      'type': 'Flexibility 🤸',
      'name': 'Yoga',
      'description': 'Yoga for begginers.',
      'image': 'images/yoga.png',
      'routines': 3,
      'level': 'Begginer',
      'time': 25,
    },
    {
      'type': 'Aerobics 🚴',
      'name': 'Cardio',
      'description': 'Get fit, stay healthy!',
      'image': 'images/cardio.png',
      'routines': 3,
      'level': 'Advanced',
      'time': 15,
    },
    {
      'type': 'Strenth Trianing 💪',
      'name': 'Core',
      'description': 'Essential strength training.',
      'image': 'images/core.png',
      'routines': 3,
      'level': 'Intermediate',
      'time': 10,
    },
    {
      'type': 'Mindfulness 🧘‍♂️',
      'name': 'Meditation',
      'description': 'Calm your mind and your soul.',
      'image': 'images/mindfulness.png',
      'routines': 3,
      'level': 'Expert',
      'time': 45,
    },
    {
      'type': 'Strength Trianing 💪',
      'name': 'Strength 201',
      'description': 'Build those tricky to get to muscles, on the spot.',
      'image': 'images/strength.png',
      'routines': 4,
      'level': 'Intermediate',
      'time': 30,
    },
  ];

  void filter() {
    setState(() {
      filters['level'] = 'All';
    });
  }

  List<Widget> buildCourses() {
    List<Widget> courseList = [];
    courseList.add(
      Text(
        'Workouts',
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    courses.forEach((element) {
      if (filters['level'] == 'All' || filters['level'] == element['level']) {
        courseList.add(
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CourseDetail()));
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: <Widget>[
                    Image.asset(
                      element['image'],
                      fit: BoxFit.fitWidth,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              element['type'],
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          element['description'],
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '📺 ${element['routines']} Routines',
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                '🔥 ${element['level']} ',
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                '🕘 ${element['time']}  minutes',
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
                  ],
                ),
              ),
            ),
          ),
        );
      }
    });
    return courseList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: FilterMenu(filter),
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              centerTitle: true,
              expandedHeight: 400,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Icons.account_circle,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
              ),
              actions: <Widget>[
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.tune),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(150),
                    child: Image.asset(
                      'images/all_around.png',
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
                      'Good morning,',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Enrique',
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
              padding: EdgeInsets.symmetric(vertical: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        'Repeat',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        padding: EdgeInsets.only(left: 20),
                        itemCount: courses.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CourseDetail()));
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
                                      courses[index]['type'],
                                      style: TextStyle(
                                          color: Colors.grey[100],
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      courses[index]['name'],
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
                          return SizedBox(
                            width: 20,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  buildCourses(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterMenu extends StatefulWidget {
  final filter;
  FilterMenu(this.filter);

  @override
  _FilterMenuState createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
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
    filters.forEach((element) {
      filterList.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              child: Text(
                element['label'],
                style: TextStyle(fontSize: 16),
              ),
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
    });
    return filterList;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
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
            Container(
              child: Text(
                'Select Filters to Apply',
                style: TextStyle(
                  fontSize: 20,
                ),
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
                onPressed: widget.filter,
                child: Text(
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
      ),
    );
  }
}
