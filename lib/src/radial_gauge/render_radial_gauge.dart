import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gauges/gauges.dart';
import 'package:gauges/src/radial_gauge/radial_ticks.dart';
import 'radial_gauge_axis.dart';
import 'radial_gauge_segment.dart';

class RenderRadialGauge extends RenderBox {
  /// Creates a RenderBox that displays a gauge.
  ///
  /// The [minAngle], [maxAngle], [minValue], [maxValue], [value] and [axisWidth] arguments must not be null.
  RenderRadialGauge({
    List<RadialGaugeAxis> axes,
    double radius,
  })  : _radius = radius,
        _axes = axes {
    markNeedsPaint();
  }

  /// The radial axe s.
  List<RadialGaugeAxis> _axes;
  List<RadialGaugeAxis> get axes => _axes;
  set axes(List<RadialGaugeAxis> value) {
    _axes = value;
    markNeedsPaint();
  }

  /// The current value of the gauge.
  double _value;
  double get value => _value;
  set value(double value) {
    if (value == _value) return;
    _value = value;
    markNeedsPaint();
  }

  /// If non-null, requires the gauge to have this radius.
  ///
  /// If null, the gauge will pick the maximum radius possible to fit its parent.
  double _radius;
  double get radius => _radius;
  set radius(double value) {
    if (value == _radius) return;
    _radius = value;
    markNeedsLayout();
  }

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    if (constraints.isTight) {
      size = Size(constraints.minWidth, constraints.minHeight);
    } else if (constraints.hasTightHeight) {
      size = Size(constraints.maxWidth, constraints.maxHeight);
    } else if (constraints.hasTightWidth) {
      size = Size(constraints.maxWidth, constraints.maxHeight);
    } else {
      double maxRadius = 0.5 *
          min(constraints.widthConstraints().maxWidth, constraints.maxHeight);
      double renderRadius = 2 * (_radius == null ? maxRadius : _radius);
      size = Size(renderRadius, renderRadius);
    }
  }

  static const degrees2Radians = pi / 180.0;

  @override
  void paint(PaintingContext context, Offset offset) {
    // Draw all the axes of the gauge.
    if (axes != null) {
      for (var axis in axes) {
        _paintAxis(axis, context, offset);
      }
    }

    super.paint(context, offset);
  }

  /// Paints the given [axis].
  void _paintAxis(
      RadialGaugeAxis axis, PaintingContext context, Offset widgetOffset) {
    context.canvas.save();

    if (axis.offsetAbsolute != null) {
      // Translate the canvas according to the axis' offset.
      context.canvas.translate(axis.offsetAbsolute.dx, axis.offsetAbsolute.dy);
    } else if (axis.offset != null) {
      context.canvas.translate(
          axis.offset.dx * size.width / 2, axis.offset.dy * size.width / 2);
    }

    // Rotate the canvas according to the axis' rotation.
    context.canvas.translate(
        widgetOffset.dx + size.width / 2, widgetOffset.dy + size.height / 2);
    context.canvas.rotate(axis.rotation * degrees2Radians);
    context.canvas.translate(
        -widgetOffset.dx - size.width / 2, -widgetOffset.dy - size.height / 2);
    // Eliminate the need to consider the offset each time
    context.canvas.translate(widgetOffset.dx, widgetOffset.dy);
    // Make it so 0° is pointing upwards (12 o'clock) instead of to the right
    // (3 o'clock) by rotating 90° to the left around the center.
    context.canvas.translate(size.width / 2, size.height / 2);
    context.canvas.rotate(-pi / 2);
    context.canvas.translate(-size.width / 2, -size.height / 2);

    // The axis is a [RadialGaugeSegment] itself.
    _paintSegment(axis, axis, context);

    // Draw all segments of the axis.
    if (axis.segments != null) {
      for (var segment in axis.segments) {
        _paintSegment(axis, segment, context);
      }
    }

    _paintPointers(context, axis);

    context.canvas.restore();
  }

  /// Paints the given [segment], including its ticks.
  ///
  /// [axis] is the axis this segment belongs to.
  void _paintSegment(RadialGaugeAxis axis, RadialGaugeSegment segment,
      PaintingContext context) {
    /// The width of the axis in pixels.
    var renderWidth;

    /// The inner radius of the axis in pixels.
    var innerRadius;

    // Absolute widths before relative widths.
    // Parent axis as fallback.
    if (segment.widthAbsolute != null) {
      renderWidth = segment.widthAbsolute;
    } else if (segment.width != null) {
      renderWidth = segment.width * size.width / 2;
    } else if (axis.widthAbsolute != null) {
      renderWidth = axis.widthAbsolute;
    } else if (axis.width != null) {
      renderWidth = axis.width * size.width / 2;
    } else {
      renderWidth = 0;
    }

    // Absolute radii before relative radii.
    // Parent axis as fallback.
    if (segment.radiusAbsolute != null) {
      innerRadius = segment.radiusAbsolute;
    } else if (segment.radius != null) {
      innerRadius = segment.radius * size.width / 2;
    } else if (axis.radiusAbsolute != null) {
      innerRadius = axis.radiusAbsolute;
    } else if (axis.radius != null) {
      innerRadius = axis.radius * size.width / 2;
    } else {
      innerRadius = 0;
    }

    /// The outer radius of the axis in pixels.
    final outerRadius = innerRadius + renderWidth;

    // Draw segment itself.
    _paintSegmentFill(context, segment, innerRadius, outerRadius);

    // Draw ticks
    _paintSegmentTicks(context, segment, innerRadius, outerRadius);
  }

  /// Paints the segment fill.
  ///
  /// [segment] is the segment the fill is drawn for.
  /// [innerRadius] is the inner radius of the segment fill.
  /// [outerRadius] is the outer radius of the segment fill.
  void _paintSegmentFill(PaintingContext context, RadialGaugeSegment segment,
      double innerRadius, double outerRadius) {
    // TODO: For different widths, see https://stackoverflow.com/questions/58212594/how-to-draw-an-arc-with-different-start-and-end-thickness-in-flutter
    if (segment.color != null || segment.gradient != null) {
      final minAngle = segment.minAngle;
      final maxAngle = segment.maxAngle;

      /// The points of the outline of the segment
      final points = [
        Offset((innerRadius) * cos(maxAngle * degrees2Radians) + size.width / 2,
            (innerRadius) * sin(maxAngle * degrees2Radians) + size.height / 2),
        Offset((innerRadius) * cos(minAngle * degrees2Radians) + size.width / 2,
            (innerRadius) * sin(minAngle * degrees2Radians) + size.height / 2),
        Offset((outerRadius) * cos(minAngle * degrees2Radians) + size.width / 2,
            (outerRadius) * sin(minAngle * degrees2Radians) + size.height / 2),
        Offset((outerRadius) * cos(maxAngle * degrees2Radians) + size.width / 2,
            (outerRadius) * sin(maxAngle * degrees2Radians) + size.height / 2),
      ];
      final innerCirclePoint = Offset(
          (innerRadius) *
                  cos((minAngle + (maxAngle - minAngle) / 2) *
                      degrees2Radians) +
              size.width / 2,
          (innerRadius) *
                  sin((minAngle + (maxAngle - minAngle) / 2) *
                      degrees2Radians) +
              size.height / 2);
      final outerCirclePoint = Offset(
          (outerRadius) *
                  cos((minAngle + (maxAngle - minAngle) / 2) *
                      degrees2Radians) +
              size.width / 2,
          (outerRadius) *
                  sin((minAngle + (maxAngle - minAngle) / 2) *
                      degrees2Radians) +
              size.height / 2);

      // Create segment outline path.
      final segmentOutlinePath = Path();
      segmentOutlinePath.moveTo(points[0].dx, points[0].dy);
      if (segment.maxAngle - segment.minAngle > 180.0) {
        segmentOutlinePath.arcToPoint(
          innerCirclePoint,
          radius: Radius.circular(innerRadius),
          clockwise: false,
        );
      }
      segmentOutlinePath.arcToPoint(
        points[1],
        radius: Radius.circular(innerRadius),
        clockwise: false,
      );
      segmentOutlinePath.lineTo(points[2].dx, points[2].dy);
      if (segment.maxAngle - segment.minAngle > 180.0) {
        segmentOutlinePath.arcToPoint(
          outerCirclePoint,
          radius: Radius.circular(outerRadius),
        );
      }
      segmentOutlinePath.arcToPoint(
        points[3],
        radius: Radius.circular(outerRadius),
      );
      segmentOutlinePath.lineTo(points[0].dx, points[0].dy);
      segmentOutlinePath.close();

      /// The paint used to fill the segment's outline.
      final segmentFillPaint = Paint();
      if (segment.gradient != null) {
        segmentFillPaint.shader = segment.gradient.createShader(Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: innerRadius));
      } else {
        segmentFillPaint.color = segment.color;
      }
      segmentFillPaint..strokeWidth = 0;
      segmentFillPaint..style = PaintingStyle.fill;
      // Draw segment.
      context.canvas.drawPath(segmentOutlinePath, segmentFillPaint);
    }
  }

  /// Paints the [RadialTick]s for the given [segment].
  void _paintSegmentTicks(PaintingContext context, RadialGaugeSegment segment,
      double innerRadius, double outerRadius) {
    if (segment.ticks != null) {
      for (RadialTicks tick in segment.ticks) {
        _paintTicks(context, segment, innerRadius, outerRadius, tick);
      }
    }
  }

  /// Paints [RadialTick]s.
  ///
  /// [segment] is the segment the ticks belong to.
  /// [innerRadius] is the inner radius when drawing the [segment],
  /// [outerRadius] is the outer radius when drawing the [segment].
  /// [parentTicks] is the parent [RadialTicks]. This is required
  /// in order to calculate ticks in between parent ticks.
  void _paintTicks(PaintingContext context, RadialGaugeSegment segment,
      double innerRadius, double outerRadius, RadialTicks tick,
      {RadialTicks parentTicks}) {
    final tickPaint = Paint()
      ..strokeWidth = tick.thickness
      ..color = tick.color;

    double start = size.width / 2;
    double end = size.width / 2;
    double length = 0;

    if (tick.lengthAbsolute != null) {
      length = tick.lengthAbsolute;
    } else {
      length = tick.length * size.width / 2;
    }

    if (tick.alignment == RadialTickAxisAlignment.inside) {
      start -= outerRadius;
      end -= outerRadius - length;
    } else if (tick.alignment == RadialTickAxisAlignment.below) {
      start -= innerRadius;
      end -= innerRadius - length;
    } else if (tick.alignment == RadialTickAxisAlignment.above) {
      start -= outerRadius + length;
      end -= outerRadius;
    }

    context.canvas.save();
    context.canvas.translate(size.width / 2, size.height / 2);
    context.canvas.rotate(-pi);
    context.canvas.translate(-size.width / 2, -size.height / 2);

    for (double angle in tick.getAngles(segment, parentTicks: parentTicks)) {
      context.canvas.save();
      context.canvas.translate(size.width / 2, size.height / 2);
      context.canvas.rotate(angle * degrees2Radians);
      context.canvas.translate(-size.width / 2, -size.height / 2);
      context.canvas.drawLine(Offset(start, size.height / 2),
          Offset(end, size.height / 2), tickPaint);
      context.canvas.restore();
    }

    context.canvas.restore();

    // Recursively draw all children
    if (tick.children != null) {
      for (var child in tick.children) {
        _paintTicks(context, segment, innerRadius, outerRadius, child,
            parentTicks: tick);
      }
    }
  }

  void _paintPointers(PaintingContext context, RadialGaugeAxis axis) {
    if (axis.pointers != null) {
      for (var pointer in axis.pointers) {
        if (pointer is RadialNeedlePointer) {
          _paintNeedlePointer(context, axis, pointer);
        }
      }
    }
  }

  void _paintNeedlePointer(PaintingContext context, RadialGaugeAxis axis,
      RadialNeedlePointer pointer) {
    // Clip the value of the needle pointer.
    var value = pointer.value;
    if (pointer.maxValue != null) value = min(value, pointer.maxValue);
    if (pointer.minValue != null) value = max(value, pointer.minValue);

    value = min(max(value, axis.minValue), axis.maxValue);
    var angle = axis.minAngle +
        ((axis.maxAngle - axis.minAngle) / (axis.maxValue - axis.minValue)) *
            (value - axis.minValue);

    /**
     * Drawing the needle.
     */

    // Rotate the canvas according to the rotation of the needle pointer.
    context.canvas.save();
    context.canvas.translate(size.width / 2, size.height / 2);
    context.canvas.rotate(angle * degrees2Radians);
    context.canvas.translate(-size.width / 2, -size.height / 2);

    var needlePaint = Paint()..style = PaintingStyle.fill;

    /// The offset of the needle pointer from the center of the axis in pixels.
    final centerOffset =
        pointer.centerOffsetAbsolute ?? pointer.centerOffset * size.width;

    /// The length of the needle pointer in pixels.
    final length = pointer.lengthAbsolute ?? pointer.length * size.width / 2;

    final thicknessStart = pointer.thicknessStart ?? pointer.thickness;
    final thicknessEnd = pointer.thicknessEnd ?? pointer.thickness;
    final thicknessMax = max(thicknessStart, thicknessEnd);

    /// The rectangle the needle is drawn in.
    final needleRect = Rect.fromLTWH(size.width / 2 + centerOffset,
        size.height / 2 - thicknessMax / 2, length, thicknessMax);

    if (pointer.gradient != null) {
      needlePaint.shader = pointer.gradient.createShader(needleRect);
    } else {
      needlePaint.color = pointer.color;
    }

    final path = Path()
      ..moveTo(
          size.width / 2 + centerOffset, size.height / 2 - thicknessStart / 2)
      ..lineTo(size.width / 2 + centerOffset + length,
          size.height / 2 - thicknessEnd / 2)
      ..lineTo(size.width / 2 + centerOffset + length,
          size.height / 2 + thicknessEnd / 2)
      ..lineTo(
          size.width / 2 + centerOffset, size.height / 2 + thicknessStart / 2)
      ..close();

    context.canvas.drawPath(path, needlePaint);

    // context.canvas.drawRect(needleRect, needlePaint);

    /**
     * Drawing the knob
     */

    // The radius of the knob in the middle of the axis in pixels.
    final knobRadius =
        pointer.knobRadiusAbsolute ?? (pointer.knobRadius * size.width / 2);

    final knobPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = pointer.knobColor;

    context.canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), knobRadius, knobPaint);

    context.canvas.restore();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('radius', radius, defaultValue: null));
    properties.add(DoubleProperty('value', value, defaultValue: null));
  }
}
