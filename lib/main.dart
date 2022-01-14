import 'package:flutter/material.dart';
import 'package:untitled/intro_page.dart';
import 'package:untitled/video_player_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroPage(),
      routes: {
        IntroPage.id: (context) => IntroPage(),
        VideoPlayerPage.id: (context) => VideoPlayerPage()
      },
    );
  }
}
