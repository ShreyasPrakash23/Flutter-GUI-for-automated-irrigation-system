import 'package:flutter/material.dart';
import 'package:flutter_app/chart.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  const MyApp({Key ? key}) : super(key:key);
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Demo',
      debugShowCheckedModeBanner: false,
      home: LiveChartWidget(),
    );
  }
}