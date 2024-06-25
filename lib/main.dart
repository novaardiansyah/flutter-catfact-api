import 'package:cat_facts_app/pages/cat_facts.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cat Facts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CatFacts(),
    );
  }
}
