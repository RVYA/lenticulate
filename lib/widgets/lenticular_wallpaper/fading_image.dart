import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:lenticulate/helper_extensions.dart';


class FadingImage extends StatelessWidget {
  const FadingImage(
    this.image, {
    required this.opacity,
  });

  final ImageProvider image;
  final double opacity;

  
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Image(image: image,),    
    );
  }
}


// TODO: Decide if HorizontalCircleCurve will be implemented.
const double _kReferenceCircleRadius = 1.0;
// ignore: unused_element
double _calculateHorizontalCircleInterval(double step) {
  step.clamp(0.0, 1.0);

  if ( step == 1.0
    || step == 0.5
    || step == 0.0 // Small optimization.
  ) {           // For the cases of 2*PI and PI, result appears to be different
    return 0.0; // than 0 when have inputted in sinus function.
  } else {
    return
      _kReferenceCircleRadius
        * math.sin(
            step
              .mapTo(
                  0.0,
                  1.0,
                  0.0,
                360.0,
              )
              .toRadian(),
          );
  }
}