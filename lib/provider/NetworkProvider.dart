import 'dart:convert';

import 'package:http/http.dart' show Client;

import '../model/movie_items.dart';

class NetworkProvider {
  Client client = Client();
  final _baseUrl = "https://211f5a56-03b1-4286-96f0-49957cf39d53.mock.pstmn.io/movies";

  Future<MovieItems> fetchMovieList() async {
    print("entered");
    final response =
        await client.get(Uri.parse("$_baseUrl"));
    print(response.body.toString());
    if (response.statusCode == 200) {
      print("Response**************** \n ${response.body.toString()}");
      // If the call to the server was successful, parse the JSON
      return MovieItems.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
