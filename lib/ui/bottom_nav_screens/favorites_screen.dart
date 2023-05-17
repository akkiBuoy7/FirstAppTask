import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:flutter/services.dart';
import '../../model/epg_item.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Channels>? channelList = [];
  late EpgItem epgItem;

  final List<String> timeEntries = [
    "6:00 AM",
    "7:00 AM",
    "8:00 AM",
    "9:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "1:00 PM",
    "2:00 PM",
    "3:00 PM",
    "4:00 PM",
    "5:00 PM",
    "6:00 PM",
    "7:00 PM",
    "8:00 PM",
    "9:00 PM",
    "10:00 PM",
    "11:00 PM",
    "12:00 AM",
    "1:00 AM",
    "2:00 AM",
    "3:00 AM",
    "4:00 AM",
    "5:00 AM"
  ];

  late LinkedScrollControllerGroup _horizontalControllersGroup;
  late ScrollController _horizontalControllerProgramme;
  late ScrollController _horizontalControllerTimeline;

  late LinkedScrollControllerGroup _verticalControllersGroup;
  late ScrollController _verticalControllerProgramme;
  late ScrollController _verticalControllerChannel;

  @override
  void initState() {
    super.initState();

    _readJsonData();

    _horizontalControllersGroup = LinkedScrollControllerGroup();
    _horizontalControllerProgramme = _horizontalControllersGroup.addAndGet();
    _horizontalControllerTimeline = _horizontalControllersGroup.addAndGet();

    _verticalControllersGroup = LinkedScrollControllerGroup();
    _verticalControllerProgramme = _verticalControllersGroup.addAndGet();
    _verticalControllerChannel = _verticalControllersGroup.addAndGet();
  }

  @override
  void dispose() {
    _horizontalControllerProgramme.dispose();
    _horizontalControllerTimeline.dispose();
    _verticalControllerProgramme.dispose();
    _verticalControllerChannel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text("EPG Screen"),
        ),
        body: FutureBuilder(
            future: _readJsonData(),
            builder: (context, data) {
              if (data.hasError) {
                return Center(
                  child: Text("${data.error}"),
                );
              } else if (data.hasData) {
                return _buildParent();
              } else {
                return _buildLoading();
              }
            }));
  }

  Widget _buildLoading() {
    return Center(
        child: CircularProgressIndicator(
      color: Colors.orange,
    ));
  }

  Widget _buildParent() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 95,
                height: 75,
                child: Center(child: Text(epgItem.today!,
                style: TextStyle(color: Colors.white),)),
                color: Colors.blueGrey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 75,
                  color: Colors.black,
                  child: _buildTimelineContainer(timeEntries),
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Row(
              children: <Widget>[
                Container(
                  width: 95,
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: _buildChannelContainer(
                    channelList!,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: _buildMainContentContainer(channelList!),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelContainer(List<Channels> channelList) {
    return SingleChildScrollView(
      controller: _verticalControllerChannel,
      child: Column(
        children: List.generate(
          channelList.length,
          (i) {
            return Padding(
              padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
              child: Container(
                height: 75,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.amberAccent),
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    channelList[i].name!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimelineContainer(List<String> timelineList) {
    return Container(
      height: 75,
      color: Colors.black,
      child: SingleChildScrollView(
        controller: _horizontalControllerTimeline,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            timelineList.length,
            (i) {
              return Container(
                height: 75,
                width: 130,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.blueGrey),
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Text(
                      timeEntries[i],
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainContentContainer(List<Channels> channelList) {
    return SingleChildScrollView(
      controller: _verticalControllerProgramme,
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _horizontalControllerProgramme,
        child: Column(
          children: List.generate(channelList.length, (y) {
            return Row(
              children:
                  List.generate(channelList[y].programs?.length ?? 0, (x) {
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: _buildProgrammeCell(channelList[y].programs![x]),
                );
              }),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildProgrammeCell(Programs programme) {
    return Container(
      height: 75,
      width: (programme.duration?.toDouble())! * 2.0,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey),
          color: Colors.white10,
          borderRadius: BorderRadius.circular(5)),
      child: Center(
          child: Text(
        programme.name!,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      )),
    );
  }

  Future<List<Channels>?> _readJsonData() async {
    final jsonData = await rootBundle.loadString('assets/json/epg.json');

    epgItem = EpgItem.fromJson(jsonDecode(jsonData));
    print(">>>>>>>>>>>>>>>>>>>>>######EPG RESPONSE${epgItem.channels?.length}");
    channelList = epgItem.channels;
    return channelList;
  }
}
