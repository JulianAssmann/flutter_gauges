import 'package:example/pages/multiple_axes_page.dart';
import 'package:example/pages/segments_page.dart';
import 'package:example/pages/ticks_in_between_page.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class DemoPage {
  final String title;
  final String path;
  final String subtitle;
  final Widget widget;

  DemoPage(this.title, this.subtitle, this.path, this.widget);
}

List<DemoPage> demoPages = [
  DemoPage(
      'Segments', 'Differently colored segments', '/segments', SegmentsPage()),
  DemoPage('Ticks in between', 'Ticks in between parent ticks',
      '/ticks_in_between', TicksInBetweenPage()),
  DemoPage('Multiple axes', 'Multiple axes in one gauge', '/multiple_axes',
      MultipleAxesPage()),
];

getRoutes(BuildContext context) {
  final map = Map<String, WidgetBuilder>();
  for (var demoPage in demoPages) {
    map.putIfAbsent(demoPage.path, () {
      return (BuildContext context) => demoPage.widget;
    });
  }
  map.putIfAbsent('/', () {
    return (BuildContext context) => HomePage();
  });
  return map;
}
