import 'dart:convert';

import 'package:http/http.dart' show Client;

import '../model/movie_items.dart';

class NetworkProvider {
  Client client = Client();

  Future<String> fetchMovieList(String _url) async {

    final response =
        await client.get(Uri.parse("$_url"));
    print(response.body.toString());
    if (response.statusCode == 200) {
      print("Response**************** \n ${response.body.toString()}");
      // If the call to the server was successful, parse the JSON
      return response.body.toString();
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
