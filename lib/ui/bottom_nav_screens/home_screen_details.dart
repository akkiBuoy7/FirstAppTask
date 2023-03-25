

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/movie_items.dart';

class HomeDetailsScreen extends StatefulWidget{

  @override
  State<HomeDetailsScreen> createState() => _HomeDetailsScreenState();

}

class _HomeDetailsScreenState extends State<HomeDetailsScreen> {

  @override
  Widget build(BuildContext context) {

    MovieDetailItems? model;
    final routeArgs1 =
    ModalRoute.of(context as BuildContext)?.settings.arguments as Map<String, MovieDetailItems?>;
    model = routeArgs1['data'];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text("${model?.movieName}"),
      ),
      body: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          color: Colors.black,
          child: Image.network(model?.imageUrl??"")
        ),
      ),
    );
  }
}