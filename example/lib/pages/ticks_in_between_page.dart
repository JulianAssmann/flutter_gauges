import 'package:flutter/material.dart';
import 'package:gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart';

class TicksInBetweenPage extends StatefulWidget {
  const TicksInBetweenPage({Key key}) : super(key: key);

  @override
  _TicksInBetweenPageState createState() => _TicksInBetweenPageState();
}

class _TicksInBetweenPageState extends State<TicksInBetweenPage> {
  double _pointerValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticks in between'),
        actions: [
          IconButton(
            icon: Icon(Icons.code_outlined),
            onPressed: () async {
              await launch(
                  'https://github.com/JulianAssmann/flutter_gauges/tree/master/example/lib/pages/ticks_in_between_page.dart');
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
                RadialGaugeAxis(
                  minValue: -100,
                  maxValue: 100,
                  minAngle: -150,
                  maxAngle: 150,
                  radius: 0.6,
                  width: 0.2,
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
                  pointers: [
                    RadialNeedlePointer(
                      minValue: -100,
                      maxValue: 100,
                      value: _pointerValue,
                      thicknessStart: 20,
                      thicknessEnd: 0,
                      color: Colors.blue,
                      length: 0.6,
                      knobRadiusAbsolute: 10,
                      gradient: LinearGradient(
                        colors: [
                          Color(Colors.blue[300].value),
                          Color(Colors.blue[300].value),
                          Color(Colors.blue[600].value),
                          Color(Colors.blue[600].value)
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
          SizedBox(height: 24),
          Slider(
              value: _pointerValue,
              min: -100,
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
