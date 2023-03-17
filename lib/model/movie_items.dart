import 'dart:convert';

/*
  Function to return Pojo class
  from raw json string
   */
MovieItems movieItemsFromJson(String str) =>
    MovieItems.fromJson(json.decode(str));

/*
  Function to return Json String
  from pojo class object
   */
String movieItemsToJson(MovieItems data) => json.encode(data.toJson());

// Actual response class
class MovieItems {
  MovieItems({
    required this.movieDetails,
    required this.page,
  });

  List<MovieDetailItems> movieDetails;
  int page;

  /*
  Function to read data of each map object from json file
  and convert it pojo class object
   */
  factory MovieItems.fromJson(Map<String, dynamic> json) => MovieItems(
        movieDetails: List<MovieDetailItems>.from(
            json["movie_details"].map((x) => MovieDetailItems.fromJson(x))),
        page: json["page"],
      );

  /*
  Function to return Map object
  from pojo class object
   */
  Map<String, dynamic> toJson() => {
        "movie_details":
            List<dynamic>.from(movieDetails.map((x) => x.toJson())),
        "page": page,
      };
}

// Each item class in the json array
class MovieDetailItems {
  MovieDetailItems({
    required this.movieName,
    required this.imageUrl,
  });

  String movieName;
  String imageUrl;

  /*
  Function to read data of each map object from json file
  and convert it pojo class object
   */
  factory MovieDetailItems.fromJson(Map<String, dynamic> json) =>
      MovieDetailItems(
        movieName: json["movie_name"],
        imageUrl: json["image_url"],
      );

  /*
  Function to return Map object
  from pojo class object
   */
  Map<String, dynamic> toJson() => {
        "movie_name": movieName,
        "image_url": imageUrl,
      };
}
