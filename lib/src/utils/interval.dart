/// A mathematical interval.
class Interval {
  /// The minimal value of the interval.
  final double min;

  /// The maximum value of the interval.
  final double max;

  /// Indicates whether or not [min] is included in this interval.
  final bool minIncluded;

  /// Indicates whether or not [max] is included in this interval.
  final bool maxIncluded;

  /// Creates an interval with the given [min] and [max] values.
  Interval(
    this.min,
    this.max, {
    this.minIncluded = true,
    this.maxIncluded = true,
  });

  /// Returns true, if [value] is inside this interval, otherwise false.
  bool contains(double value) {
    if (value == null) return false;

    bool result =
        minIncluded ? value.compareTo(min) >= 0 : value.compareTo(min) > 0;
    result &=
        maxIncluded ? value.compareTo(max) <= 0 : value.compareTo(max) < 0;
    return result;
  }

  /// Creates a copy of this [Interval] but with the
  /// given fields replaced with the new values.
  Interval copyWith(
      {double? min, double? max, bool? minIncluded, bool? maxIncluded}) {
    return Interval(
      min ?? this.min,
      max ?? this.max,
      minIncluded: minIncluded ?? this.minIncluded,
      maxIncluded: maxIncluded ?? this.maxIncluded,
    );
  }

  /// Linearly maps a [value] inside this interval to the corresponding value in interval [to].
  ///
  /// Example:
  /// ```dart
  /// final a = Interval(0, 100);
  /// final b = Interval(100, 300);
  /// double mappedValue = a.mapValueToInterval(50, b);
  /// print(mappedValue); // Prints 200
  /// ```
  double mapValueToInterval(double value, Interval to) {
    assert(value != null);
    assert(to != null);

    if (contains(value)) {
      return (value - min) * (to.max - to.min) / (max - min) + to.min;
    } else {
      throw ArgumentError.value(
          value, "value", "value is not in the interval.");
    }
  }

  /// Linearly maps a [value] inside interval [from] to the corresponding value in interval [b].
  ///
  /// Example:
  /// ```
  /// final a = Interval(0, 100);
  /// final b = Interval(100, 300);
  /// double mappedValue = Interval.mapValueFromIntervalToInterval(50, a, b);
  /// print(mappedValue); // Prints 200
  /// ```
  static double mapValueFromIntervalToInterval(
      double value, Interval a, Interval b) {
    return a.mapValueToInterval(value, b);
  }
}
