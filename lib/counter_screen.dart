import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCounterScreen extends StatefulWidget {
  const MyCounterScreen({super.key, required this.title});

  final String title;

  @override
  State<MyCounterScreen> createState() => MyCounterScreenState();
}

class MyCounterScreenState extends State<MyCounterScreen> {
  int counter = 0;

  void incrementCounter() {
    counter++;
    // setState(() {
    //   counter++;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
