// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/MyIDScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ID Analyzer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyIDScreen(),
    );
  }
}
