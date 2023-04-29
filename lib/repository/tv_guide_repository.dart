import 'dart:convert';

import 'package:first_app/provider/NetworkProvider.dart';

import '../model/tv_guide_item.dart';

class TvGuideRepository {
  Future<List<TvGuideDetails>> fetchApiData() async {
    String _url =
        "https://dfa44662-a181-4ca4-b613-9d9754818cff.mock.pstmn.io/tvguide";

    NetworkProvider networkProvider = NetworkProvider();
    final response = await networkProvider.fetchMovieList(_url);
    return TvGuideItem.fromJson(json.decode(response)).tvGuideDetails!;
  }
}
