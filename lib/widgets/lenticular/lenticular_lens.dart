import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';


enum LenticularLensEffectType {
  allAxes,
  horizontal,
  vertical,
}


enum _LenticularLensAxis {
  horizontal,
  vertical,
}


class LenticularLensController extends ChangeNotifier {
  LenticularLensController({
    final RotationAttitude initialRotation = RotationAttitude.zero,
  })
    : this._rotation = initialRotation;

  RotationAttitude _rotation;
  RotationAttitude get rotation => _rotation;

  // TODO: Implement "directions".
  ///
  ///
  ///
  void rotateHorizontally(final double attitude) {
    _rotation += RotationAttitude(horizontal: attitude, /*0.0*/);
    notifyListeners();
  }

  void rotateVertically(final double attitude) {
    // TODO: Implement.
    notifyListeners();
  }
}


const double
    _kAttitudeMin = -1,
    _kAttitudeMax =  1;

class RotationAttitude extends Equatable {
  const RotationAttitude({
    final double horizontal = 0.0,
    final double vertical = 0.0,
  })
    : assert(
        ((horizontal >= _kAttitudeMin) && (horizontal <= _kAttitudeMax))
        && ((vertical >= _kAttitudeMin) && (vertical <= _kAttitudeMax)),
        "Attitude value should be in [$_kAttitudeMin, $_kAttitudeMax] interval.",
      ),
      this._horizontal = horizontal,
      this._vertical   = vertical;

  final double
    _horizontal,
    _vertical;

  double get horizontal => _horizontal;
  double get vertical   => _vertical;


  static const RotationAttitude
      zero  =   const RotationAttitude(
                        horizontal: 0.0,
                        vertical  : 0.0,
                      ),
      top   =   const RotationAttitude(
                        horizontal: 0.0,
                        vertical  : 0.0,
                      ),
      left  =   const RotationAttitude(
                        horizontal: 0.0,
                        vertical  : 0.0,
                      ),
      right =   const RotationAttitude(
                        horizontal: 0.0,
                        vertical  : 0.0,
                      ),
      bottom =  const RotationAttitude(
                        horizontal: 0.0,
                        vertical  : 0.0,
                      );


  @override
  List<Object?> get props => <Object>[ this._horizontal, this._vertical, ];


  RotationAttitude operator +(RotationAttitude other) {
    final double
      horizontal = (this.horizontal + other.horizontal)
                    .clamp(_kAttitudeMin, _kAttitudeMax),
      vertical   = (this.vertical + other.vertical)
                    .clamp(_kAttitudeMin, _kAttitudeMax);

    return RotationAttitude(horizontal: horizontal, vertical: vertical,);
  }
}

///
/// When the device held parallel to the ground, Z axis points from ground to
/// sky (perpendicular to the ground), X axis points from left to right and
/// Y axis points from bottom of the device to top of the device (parallel to
/// the ground). When the device is yawed (rotated on Y axis), rotation to the
/// left returns "negative X values", right returns "positive X values.";
/// when the device is 
///
class LenticularLens extends StatefulWidget {
  LenticularLens._internal({
    Key? key,
    required this.controller,
    required this.effectType,
    required this.images,
  })
    : super(key: key,);

  LenticularLens.effectAllAxes({
    Key? key,
    required LenticularLensController controller,
    required List<ImageProvider> imagesColumn,
    required List<ImageProvider> imagesRow,
  })
    : this._internal(
        key       : key,
        controller: controller,
        effectType: LenticularLensEffectType.allAxes,
        images    : <_LenticularLensAxis, List<ImageProvider>>{
                      _LenticularLensAxis.horizontal: imagesRow,
                      _LenticularLensAxis.vertical  : imagesColumn,
                    },
      );

  LenticularLens.effectHorizontal({
    Key? key,
    required LenticularLensController controller,
    required List<ImageProvider> images,
  })
    : this._internal(
        key       : key,
        controller: controller,
        effectType: LenticularLensEffectType.horizontal,
        images    : <_LenticularLensAxis, List<ImageProvider>>{
                      _LenticularLensAxis.horizontal: images,
                    },
      );

  LenticularLens.effectVertical({
    Key? key,
    required LenticularLensController controller,
    required List<ImageProvider> images,
  })
    : this._internal(
        key       : key,
        controller: controller,
        effectType: LenticularLensEffectType.vertical,
        images    : <_LenticularLensAxis, List<ImageProvider>>{
                      _LenticularLensAxis.vertical: images,
                    },
      );

  
  final LenticularLensController controller;
  final LenticularLensEffectType effectType;
  final Map<_LenticularLensAxis, List<ImageProvider>> images;


  @override
  _LenticularLensState createState() => _LenticularLensState();
}

class _LenticularLensState extends State<LenticularLens> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
    );
  }
}


extension IsBetween on num {
  bool isBetween(num lowerBound, num upperBound) {
    return ((this < lowerBound) || (this > upperBound));
  }
}