import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/watchlist_bloc/tvguide_bloc.dart';

class CustomBottomSheet extends StatefulWidget {
  int? selectedValue;
  Function? callback;
  String? firstOption;
  String? secondOption;
  String? thirdOption;

  CustomBottomSheet(
      {this.selectedValue,
      this.callback,
      this.firstOption,
      this.secondOption,
      this.thirdOption});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Expanded(
            child: Theme(
              data: Theme.of(context)
                  .copyWith(unselectedWidgetColor: Colors.grey),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10),
                children: [
                  RadioListTile(
                      activeColor: Colors.red,
                      value: 0,
                      title: Text(
                        widget.firstOption!,
                        style: TextStyle(
                            color: widget.selectedValue == 0
                                ? Colors.red
                                : Colors.black),
                      ),
                      groupValue: widget.selectedValue!,
                      onChanged: (value) {
                        setState(() {
                          widget.selectedValue = value;
                        });
                      }),
                  RadioListTile(
                      activeColor: Colors.red,
                      value: 1,
                      title: Text(widget.secondOption!,
                          style: TextStyle(
                              color: widget.selectedValue ==1
                                  ? Colors.red
                                  : Colors.black)),
                      groupValue: widget.selectedValue!,
                      onChanged: (value) {
                        setState(() {
                          widget.selectedValue = value;
                        });
                      }),
                  RadioListTile(
                      activeColor: Colors.red,
                      value: 2,
                      title: Text(widget.thirdOption!,
                          style: TextStyle(
                              color: widget.selectedValue == 2
                                  ? Colors.red
                                  : Colors.black)),
                      groupValue: widget.selectedValue!,
                      onChanged: (value) {
                        setState(() {
                          widget.selectedValue = value;

                        });
                      })
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ElevatedButton(
                onPressed: () {
                  widget.callback!(widget.selectedValue);
                  Navigator.of(context).pop();
                },
                child: Text("Done")),
          )
        ],
      ),
    );
  }
}
