import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:accelerometer/accelerometer.dart';

// Looks like I am done with this.
class AccelerometerTesting extends StatefulWidget {
  @override
  _AccelerometerTestingState createState() => _AccelerometerTestingState();
}

const double _kFilteringFactor = 0.1;
final List<double> _recordVectorDelta = <double>[.0, .0, .0];
List<double> applyHighPassFilter(final List<double> vector) {
  _recordVectorDelta[0] = (vector[0] * _kFilteringFactor) + (_recordVectorDelta[0] * (1.0 - _kFilteringFactor));
  _recordVectorDelta[1] = (vector[1] * _kFilteringFactor) + (_recordVectorDelta[1] * (1.0 - _kFilteringFactor));
  _recordVectorDelta[2] = (vector[2] * _kFilteringFactor) + (_recordVectorDelta[2] * (1.0 - _kFilteringFactor));

  final List<double> filteredVector =
      <double>[
        vector[0] - _recordVectorDelta[0],
        vector[1] - _recordVectorDelta[1],
        vector[2] - _recordVectorDelta[2],
      ];

  return filteredVector;
}

int calculateInclinationOfZ(final AccelerometerEvent acceleration) {
  final double accelerationNormal =
      math.sqrt(
        (acceleration.x * acceleration.x)
        + (acceleration.y * acceleration.y)
        + (acceleration.z * acceleration.z),
      );

  return
    radianToDegrees(
      math.acos(acceleration.z / accelerationNormal),
    )
      .round();
}

int calculateInclinationOfX(final AccelerometerEvent acceleration) {
  final double accelerationNormal =
      math.sqrt(
        (acceleration.x * acceleration.x)
        + (acceleration.y * acceleration.y)
        + (acceleration.z * acceleration.z),
      );

  return
    radianToDegrees(
      math.acos(acceleration.x / accelerationNormal),
    )
      .round();
}

double radianToDegrees(double radian) {
  return (radian * 180.0) / math.pi;
}

class _AccelerometerTestingState extends State<AccelerometerTesting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<AccelerometerEvent>(
        stream: accelerometerEvents,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("LOADING..."));
          } else {
            final AccelerometerEvent event = snapshot.data!;

            final List<double> rampedAcceleration =
                applyHighPassFilter(
                  <double>[
                    event.x,
                    event.y,
                    event.z,
                  ]
                );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text("Accelerometer Data~"),
                Text("  x: ${event.x}"),
                Text("  y: ${event.y}"),
                Text("  z: ${event.z}"),
                Text("Accelerometer Data with High Pass Filter~"),
                Text("  x: ${rampedAcceleration[0]}"),
                Text("  y: ${rampedAcceleration[1]}"),
                Text("  z: ${rampedAcceleration[2]}"),
                Text("Inclination of Z is: ${calculateInclinationOfZ(event)}"),
                Text("Inclination of X is: ${calculateInclinationOfX(event)}"),
                SizedBox(width: double.infinity),
              ],
            );
          }
        }
      ),
    );
  }
}