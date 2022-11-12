import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'package:to_do_list/screens/home_screen.dart';

class App extends StatelessWidget {
  //const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(   title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home:SplashScreen(
        seconds: 3,
        navigateAfterSeconds: HomeScreen(),
        title: new Text(
          'What Todo',
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 35,
            color: Colors.lightGreen,
          ),
        ),
        backgroundColor: Colors.white70,
      ),
    );
  }
}




