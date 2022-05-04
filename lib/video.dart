import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Packages
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
      if (controller.value.position.inSeconds > 10 && !watched) {
        print('Video watched');
        watched = true;
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
              icon: Icon(
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
