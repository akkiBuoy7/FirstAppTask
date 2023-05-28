import 'dart:convert';

import 'package:first_app/provider/NetworkProvider.dart';

import '../model/tv_guide_item.dart';
import 'package:http/http.dart' show Client, Response, get;

class TvGuideRepository {

  String url = 'https://run.mocky.io/v3/38379295-243e-42d0-b912-fbf751a54ec9';

  Future<List<TvGuideDetails>> fetchApiData() async {
    NetworkProvider networkProvider = NetworkProvider();
    final response = await networkProvider.fetchMovieList(url);
    return TvGuideItem.fromJson(json.decode(response)).tvGuideDetails!;
  }

  // Future<List<TvGuideDetails>> demoApi() async {
  //     var response = await get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       return TvGuideItem.fromJson(json.decode(response.body.toString())).tvGuideDetails!;
  //     }else{
  //       return [];
  //     }
  // }
}
