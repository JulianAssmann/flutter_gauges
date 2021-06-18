import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// A radial pointer
abstract class RadialGaugePointer {
  /// The minimum value this pointer can reach.
  final double minValue;

  /// The maximum value this pointer can reach.
  final double maxValue;

  /// The value
  final double value;

  RadialGaugePointer({@required this.value, this.minValue, this.maxValue})
      : assert(value != null);
}

class RadialNeedlePointer extends RadialGaugePointer {
  /// The width of the needle.
  /// 
  /// If [thicknessStart] and [thicknessEnd] are non-null, [thickness] will be ignored.
  /// If [thickness] is non-null and [thicknessStart] is non-null, [thickness] will act as [ticknessEnd].
  /// If [thickness] is non-null and [thicknessEnd] is non-null, [thickness] will act as [ticknessStart].
  final double thickness;

  /// The width of the needle at the start of the needle (towards the center of the axis).
  /// 
  /// If [thicknessStart] and [thicknessEnd] are non-null, [thickness] will be ignored.
  /// If [thickness] is non-null and [thicknessStart] is non-null, [thickness] will act as [ticknessEnd].
  /// If [thickness] is non-null and [thicknessEnd] is non-null, [thickness] will act as [ticknessStart].
  final double thicknessStart;

  /// The width of the needle at the end of the needle (away from the center of the axis).
  /// 
  /// If [thicknessStart] and [thicknessEnd] are non-null, [thickness] will be ignored.
  /// If [thickness] is non-null and [thicknessStart] is non-null, [thickness] will act as [ticknessEnd].
  /// If [thickness] is non-null and [thicknessEnd] is non-null, [thickness] will act as [ticknessStart].
  final double thicknessEnd;

  /// The multiplier of the length is used
  /// to calculate the length for the needle.
  ///
  /// For example, if the axis has a width of 100 px and
  /// [length] is 0.6, the length of the needle is 60 px.
  ///
  /// If [lengthAbsolute] is non-null, [length] is ignored.
  final double length;

  /// The absolute length of the needle in pixels.
  ///
  /// If [lengthAbsolute] is non-null, [length] is ignored.
  final double lengthAbsolute;

  /// The offset to the center in multiples of the gauge radius.
  /// 
  /// If [centerOffsetAbsolute] is non-null, [centerOffset] is ignored.
  final double centerOffset;

  /// The offset to the center in absolute pixels.
  /// 
  /// If [centerOffsetAbsolute] is non-null, [centerOffset] is ignored.
  final double centerOffsetAbsolute;

  /// The color of the ticks.
  /// 
  /// If [gradient] is non-null, [color] is ignored.
  final Color color;

  /// The gradient for the needle of the pointer.
  /// 
  /// If [gradient] is non-null, [color] is ignored.
  final Gradient gradient;

  /// The radius of the knob of the needle as a factor of the gauge radius.
  ///
  /// If [knobRadiuisAbsolute] is non-null, [knobRadius] is ignored.
  final double knobRadius;

  /// The radius of the knob of the needle in absolute pixels.
  ///
  /// If [knobRadiusAbsolute] is non-null, [knobRadius] is ignored.
  final double knobRadiusAbsolute;

  /// The color of the knob.
  final Color knobColor;

  /// Creates a new needle pointer.
  RadialNeedlePointer({
    double minValue,
    double maxValue,
    double value,
    this.thickness = 1.0,
    this.thicknessStart,
    this.thicknessEnd,
    this.length = 1.0,
    this.lengthAbsolute,
    this.centerOffset = 0,
    this.centerOffsetAbsolute,
    this.knobRadius = 0.05,
    this.knobRadiusAbsolute,
    this.color = const Color(0xFF000000),
    this.gradient,
    this.knobColor = const Color(0xFF000000),
  })  : assert(knobRadius != null || knobRadiusAbsolute != null),
        assert(length != null || lengthAbsolute != null),
        assert(color != null || gradient != null),
        assert(thickness != null || (thicknessStart != null && thicknessEnd != null)),
        super(minValue: minValue, maxValue: maxValue, value: value);
}