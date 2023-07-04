import 'package:flutter/cupertino.dart';

class ResponsiveUi extends StatelessWidget {

  Widget mobile;
  Widget tablet;
  Widget tv;

   ResponsiveUi({Key? key,
  required this.mobile,required this.tablet,required this.tv}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    if(_size.width>=950){
      return tv;
    }else if(_size.width>=700 && _size.width<950){
      return tablet;
    }else{
      return mobile;
    }
  }
}
