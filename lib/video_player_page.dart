import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:device_info/device_info.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({Key? key}) : super(key: key);
  static final String id = "video_player_page";

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  String deviceName = '';
  String deviceVersion = '';
  String identifier = '';
  bool devideModel = true;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  int selectedVideo = 0;

  Future<void> _deviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        setState(() {
          deviceName = build.model;
          deviceVersion = build.version.toString();
          identifier = build.androidId;
          devideModel  = build.isPhysicalDevice;
        });
        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        setState(() {
          deviceName = data.name;
          deviceVersion = data.systemVersion;
          identifier = data.identifierForVendor;
        }); //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  void info() {
    print(deviceVersion);
    print(deviceName);
    print(identifier);
    print(devideModel);
  }

  @override
  void initState() {
    _controller =
        VideoPlayerController.asset("assets/videos/${selectedVideo + 1}.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _deviceDetails();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          'Tik Tok',
          style: TextStyle(fontSize: 28),
        ),
      ),
      body: PageView.builder(
        onPageChanged: (index) {
          if (selectedVideo != index) {
            _controller.pause();
          }

          setState(() {
            selectedVideo = index;

            _controller = VideoPlayerController.asset(
                "assets/videos/${selectedVideo + 1}.mp4");
            _initializeVideoPlayerFuture = _controller.initialize();
            _controller.setLooping(true);
          });

          _controller.play();
        },
        itemCount: 7,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          selectedVideo = index;
          return FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        info();
                        // If the video is playing, pause it.
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          // If the video is paused, play it.
                          _controller.play();
                        }
                      });

                    },
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.yellowAccent,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Discover"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box_outlined,
              ),
              label: " "),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.indeterminate_check_box_outlined,
              ),
              label: "Inbox"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: "Me"),
        ],
      ),
    );
  }
}
