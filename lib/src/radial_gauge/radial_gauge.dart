import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'render_radial_gauge.dart';
import 'radial_gauge_axis.dart';

/// A radial gauge.
class RadialGauge extends LeafRenderObjectWidget {
  final double radius;

  final List<RadialGaugeAxis> axes;

  const RadialGauge({
    @required this.axes,
    this.radius,
  }) : assert(axes != null && axes.length > 0);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderRadialGauge(
      radius: radius,
      axes: axes
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderRadialGauge renderObject) {
    renderObject
      ..radius = radius
      ..axes = axes;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}