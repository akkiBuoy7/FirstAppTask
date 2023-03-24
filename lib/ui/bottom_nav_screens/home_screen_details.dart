import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeDetailsScreen extends StatefulWidget{
  @override
  State<HomeDetailsScreen> createState() => _HomeDetailsScreenState();
}

class _HomeDetailsScreenState extends State<HomeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Scaffold(
        body: Container(
          child: Image.network("")
        ),
      ),
    );
  }
}