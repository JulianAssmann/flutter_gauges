# gauges

![](docs/demo.png)

Note: This project serves as a training exercise for myself in order to better understand the inner workings of Flutter and learn how to write custom `Widget`s, `Element`s and `RenderObject`s from scratch. As a result, the API might change heavily and I may not know about best practices or optimal solutions for many problems. So if you have any suggestions of improvement, please feel free to open an issue.


## Getting started

To use this plugin, add [flutter_gauges] as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

## Usage

### Radial gauge

The basic widget for radial gauges is the `RadialGauge`. Multiple `axes` can be added. E. g. this is a gauge with three axes:

<img src="docs/multiple_axes.png" width="200" height="200">

This is the basic structure of a `RadialGauge`. See the following sections for more info on each of them.

```dart
RadialGauge(
  axes: [
    RadialGaugeAxis(
        segments: [
            RadialGaugeSegment(),
            RadialGaugeSegment(),
            // ...
        ],
        pointers: [
            RadialNeedlePointer(),
            RadialNeedlePointer(),
            // ...
        ],
        ticks: [
            RadialTicks(
                children: [
                    RadialTick(),
                    RadialTick(),
                ],
            ),
            RadialTick(),
            // ...
    ),
    RadialGaugeAxis(
    ),
  ],
)
```

#### Axes

An axes has a few important properties:

- `min`: The minimum value of this axes
- `max`: The maximum value of this axes
- `minAngle`: The angle in degrees `min` is mapped to
- `maxAngle`: The angle in degrees `max` is mapped to
- `radius`: The radius of the axes as a fraction of the `RadialGauge`'s size
- `width`: The width of the axes as a fraction of the `RadialGauge`'s size
- `offset`: The offset of the axes in respect to the middle of the `RadialGauge`
- `color`: The color of the axes (gradients are also available, see examples)

For more, take a look at the examples.
 
```dart
RadialGauge(
  axes: [
    RadialGaugeAxis(
      minValue: -100,
      maxValue: 100,
      minAngle: -150,
      maxAngle: 150,
      radius: 0.6,
      width: 0.2,
    ),
  ],
)
```

#### Segments

Each axes can consist of multiple segments (it is, in fact, a segment itself). Each of the segments has a properties similiar to the `RadialGaugeAxis`. The segments are listed in the `segments` property of an axes:

```dart
RadialGauge(
  axes: [
    RadialGaugeAxis(
      color: Colors.transparent,
      // ...
      segments: [
        RadialGaugeSegment(
          minValue: 0, 
          maxValue: 20, 
          minAngle: -150, 
          maxAngle: -130,
          color: Colors.red,
        ),
        RadialGaugeSegment(
          minValue: 20, 
          maxValue: 40, 
          minAngle: -120, 
          maxAngle: -90,
          color: Colors.orange,
        ),
          // ...
      ],
    ),
  ],
)
```

<img src="docs/segments.png" width="200" height="200">

#### Ticks

Each axes can have multiple ticks of type `RadialTick`. They are listed in the `ticks` property. 
There are multiple possibilities to create ticks.

- Interval: Set the interval to the desired value. The ticks are displayed on every integer multiple of `interval`.
- Ticks in between: Set `ticksInBetween` to the desired number of ticks in between the parent ticks or the axes limits.
- Custom values: Set `values` to the desired values you want the ticks to appear at.
- Custom builder: Set `valuesBuilder` and/or `anglesBuilder` to a custom function calculating the values and/or angles at which the ticks should be displayed.

Every `RadialTick` can have `RadialTicks` as children, which is especially useful when setting the `ticksInBetween` on a children tick.

```dart
RadialGaugeAxis(
  // ...
  color: Colors.transparent,
  ticks: [
    RadialTicks(
        interval: 20,
        alignment: RadialTickAxisAlignment.inside,
        color: Colors.blue,
        length: 0.2,
        children: [
          RadialTicks(
              ticksInBetween: 5,
              length: 0.1,
              color: Colors.grey[500]),
        ])
  ],
)
```

<img src="docs/ticks_in_between.png" width="200" height="200">

#### Pointer

Each axis can have multiple pointers. Currently, there is only one type of pointer available, the `RadialNeedlePointer` with the following properties:

- `value`: The value the pointer is pointing to
- `ticknessStart`: The thickness of the pointer at the start of the pointer (in the middle of the axis)
- `ticknessEnd`: The thickness of the pointer at the end of the pointer
- `length`: The length of the pointer in fractions of the axis.
- `knobRadiusAboslute`: The radius of the pointer's knob in absolute pixels.
- `color`/`gradient`: The color/gradient filling the pointer.

The following code results in the knob shown above. For more, take a look at the examples.

```dart
RadialGaugeAxis(
    pointers: [
        RadialNeedlePointer(
            value: _pointerValue,
            thicknessStart: 20,
            thicknessEnd: 0,
            length: 0.6,
            knobRadiusAbsolute: 10,
            gradient: LinearGradient(...),
        )
    ],
)
```

### Linear gauge

Not available yet

## Maintainer
[Julian Aßmann](https://github.com/JulianAssmann)

