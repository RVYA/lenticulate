import 'package:flutter/material.dart';

import '../widgets/lenticular_wallpaper/lenticular_lens.dart';


class LenticularWallpaper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LenticularLens.effectVertical(
        images: <ImageProvider>[
          AssetImage("assets/images/flower0.jpg"),
          AssetImage("assets/images/flower1.jpg"),
          AssetImage("assets/images/flower2.jpg"),
        ],
      ),
    );
  }
}