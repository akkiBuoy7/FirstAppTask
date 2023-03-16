import 'dart:async';

import 'package:first_app/Utility/ProjectUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 5), (){
      Navigator.popAndPushNamed(context, ProjectUtil.LOGIN_SCREEN_ROUTE);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red.shade900,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 30,right: 30),
                child: Container(
                  height: 500,
                  child: Stack(
                    children: [
                      StackContainer(Colors.red.shade800,),
                      Positioned(
                          top: 30,
                          bottom: 30,
                          right: 30,
                          left: 30,
                          child: StackContainer(Colors.red.shade700)),
                      Positioned(
                          top: 60,
                          bottom:60,
                          right: 60,
                          left: 60,
                          child: StackContainer(Colors.red.shade600)),
                      Positioned(
                          top: 90,
                          bottom:90,
                          right: 90,
                          left: 90,
                          child: StackContainer(Colors.white70))
                    ],
                  ),
                ),
              ),
            ),
            Text("Durar HR",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 25),),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text("The Complete HR Solutions",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 15),),
            )
          ],
        ),
      ),
    );
  }
}

class StackContainer extends StatelessWidget {
  Color? color;

  StackContainer(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
