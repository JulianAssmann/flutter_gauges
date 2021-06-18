import 'package:flutter/material.dart';
import 'package:gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart';

class MultipleAxesPage extends StatefulWidget {
  const MultipleAxesPage({Key key}) : super(key: key);

  @override
  _MultipleAxesPageState createState() => _MultipleAxesPageState();
}

class _MultipleAxesPageState extends State<MultipleAxesPage> {
  double _pointerValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multiple axes'),
        actions: [
          IconButton(
            icon: Icon(Icons.code_outlined),
            onPressed: () async {
              await launch(
                  'https://github.com/JulianAssmann/flutter_gauges/tree/master/example/lib/pages/multiple_axes_page.dart');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: RadialGauge(
              axes: [
                // Left axis
                RadialGaugeAxis(
                  minValue: -100,
                  maxValue: 0,
                  minAngle: -150,
                  maxAngle: 0,
                  radius: 0.15,
                  width: 0.05,
                  offset: Offset(-0.2, -0.1),
                  color: Colors.red[300],
                  pointers: [
                    RadialNeedlePointer(
                      value: -100 - _pointerValue,
                      thickness: 4.0,
                      knobColor: Colors.transparent,
                      length: 0.2,
                    ),
                  ],
                  ticks: [
                    RadialTicks(
                        alignment: RadialTickAxisAlignment.below,
                        ticksInBetween: 10,
                        length: 0.05)
                  ],
                ),
                // Left axis
                RadialGaugeAxis(
                  minValue: -100,
                  maxValue: 0,
                  minAngle: 0,
                  maxAngle: 90,
                  radius: 0.15,
                  width: 0.05,
                  offset: Offset(0.2, -0.1),
                  color: Colors.green[300],
                  pointers: [
                    RadialNeedlePointer(
                      value: -100 - _pointerValue,
                      thickness: 4.0,
                      knobColor: Colors.transparent,
                      length: 0.2,
                    ),
                  ],
                  ticks: [
                    RadialTicks(
                        alignment: RadialTickAxisAlignment.above,
                        ticksInBetween: 10,
                        length: 0.05)
                  ],
                ),
                // Main axis
                RadialGaugeAxis(
                  minValue: -100,
                  maxValue: 0,
                  minAngle: -150,
                  maxAngle: 150,
                  radius: 0.6,
                  width: 0.2,
                  color: Colors.lightBlue[200],
                  ticks: [
                    RadialTicks(
                        interval: 50,
                        alignment: RadialTickAxisAlignment.inside,
                        color: Colors.black,
                        length: 0.2,
                        children: [
                          RadialTicks(
                            ticksInBetween: 5,
                            length: 0.1,
                            color: Colors.blueGrey,
                          ),
                        ])
                  ],
                  pointers: [
                    RadialNeedlePointer(
                      value: _pointerValue,
                      thicknessStart: 20,
                      thicknessEnd: 0,
                      color: Colors.lightBlue[200],
                      length: 0.6,
                      knobRadiusAbsolute: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Slider(
              value: _pointerValue,
              min: -100,
              max: 0,
              onChanged: (value) {
                setState(() {
                  _pointerValue = value;
                });
              }),
          SizedBox(height: 12),
          Text(_pointerValue.round().toString())
        ],
      ),
    );
  }
}
