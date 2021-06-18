import 'package:example/routes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gauges Demo'),
      ),
      body: ListView.separated(
        itemBuilder: (context, idx) {
          final demoPage = demoPages.elementAt(idx);
          return ListTile(
            title: Text(demoPage.title),
            subtitle: Text(demoPage.subtitle),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).pushNamed(demoPage.path);
            },
          );
        }, 
        separatorBuilder: (context, idx) {
          return Divider();
        }, 
        itemCount: demoPages.length)
    );
  }
}