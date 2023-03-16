import 'dart:convert';

MovieItems movieItemsFromJson(String str) => MovieItems.fromJson(json.decode(str));

String movieItemsToJson(MovieItems data) => json.encode(data.toJson());

class MovieItems {
  MovieItems({
    required this.movieDetails,
    required this.page,
  });

  List<MovieDetail> movieDetails;
  int page;

  factory MovieItems.fromJson(Map<String, dynamic> json) => MovieItems(
    movieDetails: List<MovieDetail>.from(json["movie_details"].map((x) => MovieDetail.fromJson(x))),
    page: json["page"],
  );

  Map<String, dynamic> toJson() => {
    "movie_details": List<dynamic>.from(movieDetails.map((x) => x.toJson())),
    "page": page,
  };
}

class MovieDetail {
  MovieDetail({
    required this.movieName,
    required this.imageUrl,
  });

  String movieName;
  String imageUrl;

  factory MovieDetail.fromJson(Map<String, dynamic> json) => MovieDetail(
    movieName: json["movie_name"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "movie_name": movieName,
    "image_url": imageUrl,
  };
}