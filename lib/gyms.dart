import 'package:flutter/material.dart';
import 'dart:convert';

// Utility Functions
import 'utility_functions.dart';

// Packages
import 'package:http/http.dart' as http;

// Routes
import 'gym_detail.dart';

class GymList extends StatefulWidget {
  const GymList({Key? key}) : super(key: key);

  @override
  _GymListState createState() => _GymListState();
}

class _GymListState extends State<GymList> {
  // Variables
  Map filters = {
    'level': 'Begginer',
  };
  List gyms = [];
  List favorites = [];

  // API Calls
  void getGyms() {
    Uri uri = Uri.parse('https://choosemyfitness-api.herokuapp.com/api/gyms/');

    http.get(uri).then((response) {
      setState(() {
        gyms = json.decode(utf8.decode(response.bodyBytes));
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
          'images/gym.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  SliverPadding favoriteGyms() {
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
                'Favorite Gyms',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: favorites.isNotEmpty
                  ? ListView.separated(
                      padding: const EdgeInsets.only(left: 20),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GymDetail(
                                          gym: gyms[index],
                                        )));
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
                                    gyms[index]['chain']['name'],
                                    style: TextStyle(
                                        color: Colors.grey[100],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Text(
                                    gyms[index]['name'],
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
                      itemCount: favorites.length,
                    )
                  : const Center(
                      child: Text('You have no favorites'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  SliverPadding buildGyms() {
    List<Widget> gymList = [];
    gymList.add(
      Text(
        'Gyms',
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    for (var element in gyms) {
      gymList.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GymDetail(gym: element)));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
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
                            element['chain']['name'],
                            style: const TextStyle(
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        element['address'],
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '🕘 ${parseTime(element['open'])} - ${parseTime(element['close'])}',
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      ),
                      Text(
                        element['workouts'].length == 1
                            ? '⚡️ ${element['workouts'].length} Class'
                            : '⚡️ ${element['workouts'].length} Classes',
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      ),
                      Text(
                        '📍 ${calculateDistance(latitude: element['latitude'], longitude: element['longitude'])}km away',
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      toggleFavorite(element);
                    },
                    child: const Icon(Icons.favorite_border),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          gymList,
        ),
      ),
    );
  }

  // View Methods
  void toggleFavorite(Map element) {
    setState(() {
      favorites.contains(element)
          ? favorites.remove(element)
          : favorites.add(element);
    });

    favorites.contains(element)
        ? ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${element['name']} added to favorites.')))
        : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${element['name']} removed from favorites.')));
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
    getGyms();
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
      child: gyms.isNotEmpty
          ? CustomScrollView(
              slivers: <Widget>[
                appBar(),
                favoriteGyms(),
                buildGyms(),
              ],
            )
          : const CircularProgressIndicator(),
    );
  }
}
