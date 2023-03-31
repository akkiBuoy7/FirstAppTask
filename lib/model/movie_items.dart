// To parse this JSON data, do
//
//     final movieItems = movieItemsFromJson(jsonString);

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
    required this.rating,
    required this.director,
    required this.video,
    required this.description,
  });

  String movieName;
  String imageUrl;
  int rating;
  String director;
  Video video;
  String description;

  factory MovieDetail.fromJson(Map<String, dynamic> json) => MovieDetail(
    movieName: json["movie_name"],
    imageUrl: json["image_url"],
    rating: json["rating"],
    director: json["director"],
    video: Video.fromJson(json["video"]),
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "movie_name": movieName,
    "image_url": imageUrl,
    "rating": rating,
    "director": director,
    "video": video.toJson(),
    "description": description,
  };
}

class Video {
  Video({
    required this.url,
    required this.thumbnail,
  });

  String url;
  String thumbnail;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    url: json["url"],
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "thumbnail": thumbnail,
  };
}
