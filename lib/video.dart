import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Models
import 'user.dart';

// Packages
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Video extends StatefulWidget {
  final Map workout;
  const Video({Key? key, required this.workout}) : super(key: key);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  // Variables
  late YoutubePlayerController controller;
  bool watched = false;

  // API Calls
  void addSession() async {
    Uri uri = Uri.parse(
        'https://choosemyfitness-api.herokuapp.com/api/virtual_workouts/sessions/');

    http.post(uri, body: {
      'user':
          Provider.of<UserData>(context, listen: false).user['id'].toString(),
      'virtual_workout': widget.workout['id'].toString(),
    }).then(
        (value) => Provider.of<UserData>(context, listen: false).updateUser());
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    controller = YoutubePlayerController(
      initialVideoId: widget.workout['video'],
      flags: const YoutubePlayerFlags(),
    );
    controller.addListener(() {
      if (controller.value.position.inSeconds >
              widget.workout['duration'] * 30 &&
          !watched) {
        addSession();
        watched = true;
        print('Watched video');
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: controller,
          topActions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
          bottomActions: <Widget>[
            const SizedBox(width: 14.0),
            CurrentPosition(),
            const SizedBox(width: 8.0),
            ProgressBar(
              isExpanded: true,
            ),
            RemainingDuration(),
          ],
        ),
        builder: (context, player) {
          return player;
        },
      ),
    );
  }
}
