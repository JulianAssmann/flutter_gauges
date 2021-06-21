import 'dart:ui';
import 'package:gauges/gauges.dart';

typedef TickValuesBuilder = List<double> Function(
    RadialGaugeSegment segment, RadialTicks tickConfig);
typedef TickAnglesBuilder = List<double> Function(RadialGaugeSegment segment,
    RadialTicks tickConfig, List<double>? tickValues);

/// Alignment of elements with respect to an axis.
enum RadialTickAxisAlignment {
  /// Places the element inside the axis
  inside,

  /// Places the element on the side of the axis facing
  /// the center of the circle defining the axis.
  below,

  /// Places the element on the side of the axis facing
  /// away from the center of the circle defining the axis.
  above,
}

class RadialTicks {
  /// The number of ticks in between two ticks of the parent ticks.
  /// If there are no parent ticks, this is the number of ticks between
  /// the [minValue] and the [maxValue] of the [RadialGaugeSegment]
  /// the ticks are defined for.
  ///
  /// If [interval], [values] or [valuesBuilder] is set, [ticksInBetween] is ignored.
  final int? ticksInBetween;

  /// The interval between two values with a tick.
  ///
  /// If [values] or [valuesBuilder] is set, this is ignored.
  final double? interval;

  /// The values where major ticks are located.
  ///
  /// If this is set, [interval] is ignored.
  /// If [valuesBuilder] is set, [values] is ignored.
  final List<double>? values;

  /// A function that generates the tick values.
  ///
  /// If this is set, [interval], [ticksInBetween] and [values] are ignored.
  final TickValuesBuilder? valuesBuilder;

  /// A function that generates the angle corresponding to given values.
  final TickAnglesBuilder? anglesBuilder;

  /// The alignment of the ticks with respect
  /// to the segment/axis they are defined on.
  final RadialTickAxisAlignment alignment;

  /// List of subordinate ticks.
  final List<RadialTicks>? children;

  /// The width of each tick.
  final double thickness;

  /// The length of the ticks in mutliples of the gauge
  ///
  /// For example, if the gauge has a radius of 100 px and
  /// [length] is 0.2, the length of each tick is 20 px.
  ///
  /// If [lengthAbsolute] is non-null, [length] is ignored.
  final double length;

  /// The absolute length of the ticks in pixels.
  ///
  /// If [lengthAbsolute] is non-null, [length] is ignored.
  final double? lengthAbsolute;

  /// The color of the ticks.
  final Color color;

  /// Creates a new radial tick configuration.
  RadialTicks({
    this.interval,
    this.ticksInBetween,
    this.values,
    this.valuesBuilder,
    this.anglesBuilder,
    this.children,
    this.alignment = RadialTickAxisAlignment.inside,
    this.thickness = 2,
    this.length = 1.0,
    this.lengthAbsolute,
    this.color = const Color(0xFF000000),
  }) : assert(!(interval == null &&
            ticksInBetween == null &&
            values == null &&
            valuesBuilder == null));

  /// Cached tick values.
  List<double>? _cachedTickValues;

  /// Calculates and returns a list of the values where ticks should be.
  ///
  /// [segment] is the segment the tick values are generated for.
  List<double>? getValues(RadialGaugeSegment segment,
      {RadialTicks? parentTicks}) {
    if (_cachedTickValues == null) {
      if (valuesBuilder != null) {
        // User-defined generator for tick values
        _cachedTickValues = valuesBuilder!(segment, this);
      } else if (values != null) {
        // User-defined tick values
        _cachedTickValues = values;
      } else if (interval != null) {
        // Regular intervals
        int valueCount =
            ((segment.maxValue - segment.minValue) ~/ interval!) + 1;
        if (valueCount > 0)
          _cachedTickValues = List<double>.generate(
              valueCount, (i) => segment.minValue + i * interval!);
        else
          _cachedTickValues = <double>[];
      } else if (ticksInBetween != null) {
        // Ticks in between two other ticks when parentTicks is not null.
        // Otherwise ticks in between the min and max value of the segment.
        if (parentTicks != null) {
          _cachedTickValues = <double>[];
          final values = parentTicks.getValues(segment)!;
          for (var i = 0; i < values.length - 1; ++i) {
            final currentVal = values[i];
            final nextVal = values[i + 1];
            final interval = (nextVal - currentVal) / (ticksInBetween! + 1);
            _cachedTickValues!.addAll(List<double>.generate(
                ticksInBetween!, (i) => currentVal + (i + 1) * interval));
          }
        } else {
          final interval =
              (segment.maxValue - segment.minValue) / (ticksInBetween! + 1);
          _cachedTickValues = List<double>.generate(
              ticksInBetween!, (i) => segment.minValue + (i + 1) * interval);
        }
      } else {
        // No ticks
        _cachedTickValues = <double>[];
      }
    } else {
      return _cachedTickValues;
    }
  }

  /// Cached tick angles.
  List<double>? _cachedTickAngles;

  /// Calculates and returns a list of the angles where ticks should be.
  ///
  /// [segment] is the segment the tick angles are generated for.
  List<double>? getAngles(RadialGaugeSegment segment,
      {RadialTicks? parentTicks}) {
    if (_cachedTickValues == null) getValues(segment, parentTicks: parentTicks);

    if (_cachedTickAngles == null) {
      if (anglesBuilder != null) {
        _cachedTickAngles = anglesBuilder!(segment, this, _cachedTickValues);
      } else {
        final angleInc = (segment.maxAngle - segment.minAngle) /
            (segment.maxValue - segment.minValue);

        _cachedTickAngles = _cachedTickValues!
            .map((i) => segment.minAngle + (i - segment.minValue) * angleInc)
            .toList();
      }
    }

    return _cachedTickAngles;
  }
}

// class Tick {
//   final double value;
//   final String label;
// }
