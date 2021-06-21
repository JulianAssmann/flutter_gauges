import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:gauges/src/radial_gauge/radial_gauge_pointer.dart';
import 'package:gauges/src/radial_gauge/radial_ticks.dart';

import 'radial_gauge_segment.dart';

/// An axis for a radial gauge.
class RadialGaugeAxis extends RadialGaugeSegment {
  /// The segments for this axis.
  ///
  /// If null, there is one singular segment for the entire axis.
  final List<RadialGaugeSegment>? segments;

  /// The pointers for this axis.
  final List<RadialGaugePointer>? pointers;

  /// The offset of this axis as a factor of the gauge size.
  ///
  /// Is ignored, when [offsetAbsolute] is set.
  final Offset? offset;

  /// The offset of this axis in absolute pixels.
  ///
  /// When set to a non-null value, [offset] is ignored.
  final Offset? offsetAbsolute;

  /// The rotation of this axis in degrees.
  final double rotation;

  /// Creates a radial gauge axis.
  ///
  /// [minValue] is the minimum value of this axis,
  /// [maxValue] is the maximum value of this axis.
  /// [minAngle] is the minimum angle used to represent the [minValue].
  /// [maxAngle] is the maximum angle used to represent the [maxValue].
  ///
  /// The body of the segment is painted in layers. The bottom-most layer is the
  /// [color], which fills the box. Above that is the [gradient], which also fills
  /// the box. Finally there is the [image], the precise alignment of which is
  /// controlled by the [DecorationImage] class.
  RadialGaugeAxis({
    required double minValue,
    required double maxValue,
    double minAngle = -150.0,
    double maxAngle = 150.0,
    double radius = 0.8,
    double? radiusAbsolute,
    double width = 0.2,
    double? widthAbsolute,
    List<RadialTicks>? ticks,
    this.pointers,
    Color? color,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    Border? border,
    BorderRadiusGeometry? borderRadius,
    this.segments,
    this.offsetAbsolute,
    this.offset,
    this.rotation = 0,
  })  : assert(minValue != null),
        assert(maxValue != null),
        assert(minAngle != null),
        assert(maxAngle != null),
        super(
            minValue: minValue,
            maxValue: maxValue,
            minAngle: minAngle,
            maxAngle: maxAngle,
            ticks: ticks,
            radius: radius,
            radiusAbsolute: radiusAbsolute,
            width: width,
            widthAbsolute: widthAbsolute,
            color: color,
            gradient: gradient,
            backgroundBlendMode: backgroundBlendMode,
            border: border,
            borderRadius: borderRadius);
}
