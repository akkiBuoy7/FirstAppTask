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
  EpgItem epgItem = EpgItem();

  final List<String> colEntries = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split('');
  final List<String> rowEntries =
      Iterable<int>.generate(15).map((e) => e.toString()).toList();

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
                width: 75,
                height: 75,
                color: Colors.grey[200],
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Container(
                  height: 75,
                  color: Colors.orange[100],
                  child: _buildTimelineContainer(rowEntries),
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Row(
              children: <Widget>[
                Container(
                  width: 75,
                  color: Colors.blue[100],
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
            return Container(
              height: 75,
              width: 75,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
              child: Center(child: Text(channelList[i].name!)),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimelineContainer(List<String> timelineList) {
    return Container(
      height: 75,
      color: Colors.orange[100],
      child: SingleChildScrollView(
        controller: _horizontalControllerTimeline,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            timelineList.length,
            (i) {
              return Container(
                height: 75,
                width: 75,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.white)),
                child: Center(child: Text(rowEntries[i])),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _horizontalControllerProgramme,
        child: Column(
          children: List.generate(channelList.length, (y) {
            return Row(
              children:
                  List.generate(channelList[y].programs?.length ?? 0, (x) {
                return _buildProgrammeCell(channelList[y].programs![x]);
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
      width: programme.duration?.toDouble(),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Center(child: Text(programme.name!)),
    );
  }

  Future<List<Channels>?> _readJsonData() async {
    final jsonData = await rootBundle.loadString('assets/json/epg.json');

    var epgItem = EpgItem.fromJson(jsonDecode(jsonData));
    print(">>>>>>>>>>>>>>>>>>>>>######EPG RESPONSE${epgItem.channels?.length}");
    channelList = epgItem.channels;
    return channelList;
  }
}
