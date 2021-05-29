import 'dart:math' as math;
import 'dart:typed_data' as typed_data show Uint8List;
import 'dart:ui';

import 'package:flutter/painting.dart' show ImageProvider, MemoryImage;

import 'package:equatable/equatable.dart';


enum FadingGradientType { linear, radial, }


const double
    _kGradientRadialCenter    = 0.0,
    _kGradientRadialRadiusMax = 1.0;
const double _kFadeReferenceCircleRadius = 1.0;


double _calculateRadian(double angle) => (math.pi * angle) / 180.0;
double _clampInUnitInterval(double value) => math.max(0.0, math.min(value, 1.0));
double _mapOnInterval(double min, double max, double value) {
  return math.max(min, math.min(value * max, max));
}


double _calculateHorizontalCircleInterval(double step) {
  step = _clampInUnitInterval(step);

  if ( step == 1.0
    || step == 0.5
    || step == 0.0 // Small optimization.
  ) {           // For the cases of 2*PI and PI, result appears to be different
    return 0.0; // than 0 when have inputted in sinus function.
  } else {
    return
      _kFadeReferenceCircleRadius
        * math.sin(
            _calculateRadian(
              _mapOnInterval(0.0, 360.0, step),
            ),
          );
  }
}


class FadingImage extends Equatable {
  FadingImage({
    required this.gradientType,
    required this.imageBytes,
  });


  final FadingGradientType gradientType;
  final typed_data.Uint8List imageBytes;

  @override
  List<Object?> get props => <Object>[ this.gradientType, this.imageBytes, ];


  /*typed_data.Uint8List fadeImage(final double step) {
    final double fadeOffset = _calculateHorizontalCircleInterval(step);
    Image a = Image();a.
    return null;
  }*/
}