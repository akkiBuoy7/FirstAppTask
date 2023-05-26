import 'dart:convert';

import 'package:first_app/provider/NetworkProvider.dart';

import '../model/tv_guide_item.dart';

class TvGuideRepository {
  Future<List<TvGuideDetails>> fetchApiData() async {
    String _url =
        "https://run.mocky.io/v3/38379295-243e-42d0-b912-fbf751a54ec9";

    NetworkProvider networkProvider = NetworkProvider();
    final response = await networkProvider.fetchMovieList(_url);
    return TvGuideItem.fromJson(json.decode(response)).tvGuideDetails!;
  }
}
