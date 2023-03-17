import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WatchlistScreen extends StatefulWidget{
  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Watch List",style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
    );
  }
}