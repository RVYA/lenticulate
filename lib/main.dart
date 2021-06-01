import 'package:flutter/material.dart';

import 'package:lenticulate/screens/accelerometer_testing.dart';
import 'screens/lenticular_wallpaper.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lenticulate",
      home: LenticularWallpaper(),
    );
  }
}