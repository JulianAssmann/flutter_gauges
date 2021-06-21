import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart';

class SegmentsPage extends StatefulWidget {
  const SegmentsPage({Key? key}) : super(key: key);

  @override
  _SegmentsPageState createState() => _SegmentsPageState();
}

class _SegmentsPageState extends State<SegmentsPage> {
  double _pointerValue = 0;

  @override
  Widget build(BuildContext context) {
    final size = min(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height) -
        100;
    return Scaffold(
      appBar: AppBar(
        title: Text('Segments'),
        actions: [
          IconButton(
            icon: Icon(Icons.code_outlined),
            onPressed: () async {
              await launch(
                  'https://github.com/JulianAssmann/flutter_gauges/tree/master/example/lib/pages/segments_page.dart');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: RadialGauge(
                axes: [
                  RadialGaugeAxis(
                    minValue: 0,
                    maxValue: 100,
                    minAngle: -150,
                    maxAngle: 150,
                    radius: 0.6,
                    width: 0.2,
                    segments: [
                      RadialGaugeSegment(
                        minValue: 0,
                        maxValue: 20,
                        minAngle: -150,
                        maxAngle: -150 + 60.0 - 1,
                        color: Colors.red,
                      ),
                      RadialGaugeSegment(
                        minValue: 20,
                        maxValue: 40,
                        minAngle: -150.0 + 60,
                        maxAngle: -150.0 + 120 - 1,
                        color: Colors.orange,
                      ),
                      RadialGaugeSegment(
                        minValue: 40,
                        maxValue: 60,
                        minAngle: -150.0 + 120,
                        maxAngle: -150.0 + 180 - 1,
                        color: Colors.yellow,
                      ),
                      RadialGaugeSegment(
                        minValue: 60,
                        maxValue: 80,
                        minAngle: -150.0 + 180,
                        maxAngle: -150.0 + 240 - 1,
                        color: Colors.lightGreen,
                      ),
                      RadialGaugeSegment(
                        minValue: 80,
                        maxValue: 100,
                        minAngle: -150.0 + 240,
                        maxAngle: -150.0 + 300,
                        color: Colors.green,
                      ),
                    ],
                    pointers: [
                      RadialNeedlePointer(
                        value: _pointerValue,
                        thicknessStart: 20,
                        thicknessEnd: 0,
                        length: 0.6,
                        knobRadiusAbsolute: 10,
                        gradient: LinearGradient(
                          colors: [
                            Color(Colors.grey[400]!.value),
                            Color(Colors.grey[400]!.value),
                            Color(Colors.grey[600]!.value),
                            Color(Colors.grey[600]!.value)
                          ],
                          stops: [0, 0.5, 0.5, 1],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Slider(
              value: _pointerValue,
              min: 0,
              max: 100,
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
