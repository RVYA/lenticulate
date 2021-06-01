import 'package:flutter/material.dart';

import 'package:accelerometer/accelerometer.dart';

import '../../helper_extensions.dart';
import 'fading_image.dart';


enum LenticularLensEffectType {
  allAxes,
  vertical,
}


enum _LenticularLensAxis {
  horizontal,
  vertical,
}

const _LenticularLensAxis
  _kH = _LenticularLensAxis.horizontal,
  _kV =   _LenticularLensAxis.vertical;


const int
  _kInclinationLower  =   0,
  _kInclinationUpper  = 180;


/// When device screen is facing you, in portrait mode, +z is towards you
/// and device is perpendicular to the ground. Until device is flat, which means
/// device screen (+z) points towards sky or ground and y axis is (about)
/// parallel to the ground, only available option is to pitch the phone (rotate
/// on x axis) to imitiate the lenticular lens effect. When the device is
/// about flat (there is a little error margin in angles), then in addition to
/// the pitch, the yaw (rotation on y axis) can be used to imitiate the effect
/// horizontally, too.
class LenticularLens extends StatefulWidget {
  const LenticularLens._internal({
    Key? key,
    required this.effectType,
    required this.images,
  })
    : super(key: key,);

  LenticularLens.effectAllAxes({
    Key? key,
    required List<ImageProvider> imagesColumn,
    required List<ImageProvider> imagesRow,
  })
    : this._internal(
        key       : key,
        effectType: LenticularLensEffectType.allAxes,
        images    : <_LenticularLensAxis, List<ImageProvider>>{
                      _LenticularLensAxis.horizontal: imagesRow,
                      _LenticularLensAxis.vertical  : imagesColumn,
                    },
      );

  LenticularLens.effectVertical({
    Key? key,
    required List<ImageProvider> images,
  })
    : this._internal(
        key       : key,
        effectType: LenticularLensEffectType.vertical,
        images    : <_LenticularLensAxis, List<ImageProvider>>{
                      _LenticularLensAxis.vertical: images,
                    },
      );


  final LenticularLensEffectType effectType;
  final Map<_LenticularLensAxis, List<ImageProvider>> images;


  @override
  _LenticularLensState createState() => _LenticularLensState();
}

class _LenticularLensState extends State<LenticularLens> {
  List<Widget> buildImages(int inclination,) {
    final List<Widget> imageStack = List<Widget>.empty(growable: true);

    final double verticalStep = inclination.mapTo(
                                  _kInclinationLower, _kInclinationUpper,
                                  0, widget.images[_kV]!.length,
                                ) as double;
    final int verticalIndex = verticalStep.floor();
    double opacity = verticalStep - verticalIndex;
    if (opacity == 0.0) opacity = 1.0;

    if (verticalIndex > 0) {
      final FadingImage backgroundImage =
        FadingImage(
          widget.images[_kV]![verticalIndex - 1],
          opacity: 1.0,
        );

      imageStack.add(RepaintBoundary(child: backgroundImage));
    }

    final FadingImage coverImage =
      FadingImage(
        widget.images[_kV]![verticalIndex],
        opacity: opacity,
      );
    
    imageStack.add(RepaintBoundary(child: coverImage));

    return imageStack;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AccelerometerEvent>(
      stream: accelerometerEvents,
      builder: (_, AsyncSnapshot<AccelerometerEvent> snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Text("Loading...");
        }
        // TODO: Implement horizontal rotation.
        final int verticalInclination =
            snapshot.data!.calculateDeviceZInclination();

        return Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: buildImages(verticalInclination,),
        );
      }
    );
  }
}