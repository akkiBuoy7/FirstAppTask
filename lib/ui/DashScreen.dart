import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashScreen extends StatefulWidget{
  const DashScreen({super.key});

  @override
  State<DashScreen> createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Home Screen"),
    );
  }
}