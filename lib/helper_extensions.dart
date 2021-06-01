import 'dart:math' as math show pi;


extension IsBetween on num {
  bool isBetween(num lowerBound, num upperBound) {
    return ((this < lowerBound) || (this > upperBound));
  }
}

extension MapTo on num {
  num mapTo(
    num currentRangeLower, num currentRangeUpper,
    num desiredRangeLower, num desiredRangeUpper,
  ) {
    assert(
      (currentRangeUpper > currentRangeLower)
      && (desiredRangeUpper > desiredRangeLower),
      "Given intervals should conform the rule {Upper Bound > Lower Bound}."
    );

    return
        (this - currentRangeLower) / (currentRangeUpper - currentRangeLower)
        * (desiredRangeUpper - desiredRangeLower) + desiredRangeLower;
  }
}

extension ToRadian on num {
  double toRadian() => (math.pi * this) / 180.0;
}