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
                              child: SingleChildScrollView(
                                controller: _horizontalControllerTimeline,
                                scrollDirection: Axis.horizontal,
                                child: HeaderContainer(rowEntries: rowEntries),
                              ),
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
                              child: SingleChildScrollView(
                                controller: _verticalControllerChannel,
                                child: ColumnContainer(
                                  colEntries: channelList!,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: SizedBox(
                                child: SingleChildScrollView(
                                  controller: _verticalControllerProgramme,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    controller: _horizontalControllerProgramme,
                                    child: BodyContainer(
                                      colEntries: channelList!
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.orange,
                ));
              }
            }));
  }

  Future<List<Channels>?> _readJsonData() async {
    final jsonData = await rootBundle.loadString('assets/json/epg.json');

    var epgItem = EpgItem.fromJson(jsonDecode(jsonData));
    print(">>>>>>>>>>>>>>>>>>>>>######EPG RESPONSE${epgItem.channels?.length}");
    channelList = epgItem.channels;
    return channelList;
  }
}

class Tile extends StatelessWidget {
  final String caption;

  Tile(this.caption);

  @override
  Widget build(_) => Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        height: 250.0,
        child: Center(child: Text(caption)),
      );
}

class ColumnContainer extends StatelessWidget {
  final List<Channels> colEntries;

  const ColumnContainer({
    Key? key,
    required this.colEntries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int numberOfRows = colEntries.length;
    return Column(
      children: List.generate(
        numberOfRows,
        (i) {
          return Container(
            height: 75,
            width: 75,
            decoration: BoxDecoration(border: Border.all(color: Colors.white)),
            child: Center(child: Text(colEntries[i].name!)),
          );
        },
      ),
    );
  }
}

class HeaderContainer extends StatelessWidget {
  final List<String> rowEntries;

  const HeaderContainer({
    Key? key,
    required this.rowEntries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int numberOfColumns = rowEntries.length;
    return Row(
      children: List.generate(
        numberOfColumns,
        (i) {
          return Container(
            height: 75,
            width: 75,
            decoration: BoxDecoration(border: Border.all(color: Colors.white)),
            child: Center(child: Text(rowEntries[i])),
          );
        },
      ),
    );
  }
}

class BodyContainer extends StatelessWidget {
  final List<Channels> colEntries;

  const BodyContainer({
    Key? key,
    required this.colEntries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(colEntries.length, (y) {
        return Row(
          children: List.generate(colEntries[y].programs?.length??0, (x) {
            return TableCell(programme: colEntries[y].programs![x]);
          }),
        );
      }),
    );
  }
}

class TableCell extends StatelessWidget {
  final Programs programme;
  const TableCell({
    Key? key,
    required this.programme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: programme.duration?.toDouble(),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Center(child: Text(programme.name!)),
    );
  }
}
