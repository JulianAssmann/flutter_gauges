import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gauges/src/radial_gauge/radial_ticks.dart';
import 'radial_gauge_axis.dart';

/// A segment of a radial gauge axis.
class RadialGaugeSegment {
  /// The angle used to represents [minValue].
  final double minAngle;

  /// The angle used to represent [maxValue].
  final double maxAngle;

  /// The minimum value.
  final double minValue;

  /// The maximum value.
  final double maxValue;

  /// The configurations for the ticks of this segment.
  final List<RadialTicks> ticks;

  /// The width of the segment in fractions of the gauge radius.
  ///
  /// If [widthAbsolute] is non-null, [width] is ignored.
  ///
  /// If bot [widthAbsolute] and [width] are null,
  /// the width of the [RadialGaugeAxis] this segment belongs to is used.
  final double width;

  /// The width of the segment in pixels.
  ///
  /// If [widthAbsolute] is non-null, [width] is ignored.
  ///
  /// If bot [widthAbsolute] and [width] are null,
  /// the width of the [RadialGaugeAxis] this segment belongs to is used.
  final double widthAbsolute;

  /// The radius of this segments in fractions of the gauge radius.
  ///
  /// If [radiusAbsolute] is non-null, [radius] is ignored.
  ///
  /// If bot [radius] and [radiusAbsolute] is are null,
  /// the radius of the [RadialGaugeAxis] this segment belongs to is used.
  final double radius;

  /// The radius of this segment in pixels.
  ///
  /// If non-null, [radius] is ignored.
  ///
  /// If bot [radius] and [radiusAbsolute] is are null,
  /// the radius of the [RadialGaugeAxis] this segment belongs to is used.
  final double radiusAbsolute;

  /// A color gradient to use when drawing the background of the segment.
  ///
  /// If this is specified, [color] has no effect.
  final Gradient gradient;

  /// The color to fill in the background of the segment.
  ///
  /// This is ignored if [gradient] is non-null.
  final Color color;

  /// A border to draw above the the [color] or [gradient].
  final Border border;

  /// If non-null, the corners of the segment are rounded by this [BorderRadius].
  final BorderRadiusGeometry borderRadius;

  ///The blend mode applied to the [color] or [gradient] background of the segment.
  ///
  /// If no [backgroundBlendMode] is provided then the default painting blend mode is used.
  ///
  /// If no [color] or [gradient] is provided then the blend mode has no impact.
  final BlendMode backgroundBlendMode;

  /// Creates a radial gauge segment.
  ///
  /// [minValue] is the minimum value of this axis,
  /// [maxValue] is the maximum value of this axis.
  /// [minAngle] is the minimum angle used to represent the [minValue].
  /// [maxAngle] is the maximum angle used to represent the [maxValue].
  ///
  /// The body of the segment is painted in layers. The bottom-most layer is the
  /// [color], which fills the segment. Above that is the [gradient], which also fills
  /// the segment.
  const RadialGaugeSegment({
      @required this.minValue,
      @required this.maxValue,
      @required this.minAngle,
      @required this.maxAngle,
      this.ticks,
      this.width,
      this.widthAbsolute,
      this.radius,
      this.radiusAbsolute,
      this.gradient,
      this.color,
      this.border,
      this.borderRadius,
      this.backgroundBlendMode})
      : assert(
            backgroundBlendMode == null || color != null || gradient != null,
            "backgroundBlendMode applies to RadialGaugeSegments's background color or "
            'gradient, but no color or gradient was provided.'),
        assert(maxAngle - minAngle <= 360.0, "The difference between maxAngle and minAngle must be less or equal to 360°"),
        assert(maxAngle > minAngle, "The maxAngle must be greater than the minAngle");

  /// Creates a copy of the instance and replaces the given variables of that copy.
  RadialGaugeSegment copyWith(
      {double minValue,
      double maxValue,
      double minAngle,
      double maxAngle,
      double width,
      Gradient gradient,
      Color color,
      Border border,
      BorderRadiusGeometry borderRadius,
      BlendMode backgroundBlendMode}) {
    return RadialGaugeSegment(
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      minAngle: minAngle ?? this.minAngle,
      maxAngle: maxAngle ?? this.maxAngle,
      width: width ?? this.width,
      gradient: gradient ?? this.gradient,
      color: color ?? this.color,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundBlendMode: backgroundBlendMode ?? this.backgroundBlendMode,
    );
  }
}
