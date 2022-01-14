import 'package:flutter/material.dart';
import 'package:untitled/video_player_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);
  static final String id = "intro_page";

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<Offset> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 7));

    _animation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -2),
    ).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));

    _animationController.forward();
    _animationController.addStatusListener((status) {

      if(status == AnimationStatus.completed){
        Navigator.of(context).pushReplacementNamed(VideoPlayerPage.id);

      }

    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SlideTransition(
        position: _animation,

        child: Center(
          child: Image(
            height: 150,
            width: 150,
            image: AssetImage("assets/images/img.png"),

          ),

        ),


      ),
    );
  }
}
