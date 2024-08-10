class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;
  final double popularity;
  bool? adult;
  int? budget;
  List<String>? genres;
  String? homepage;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.popularity,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    Movie temp = Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
      releaseDate: json['release_date'] ?? '',
      popularity: (json['popularity'] as num).toDouble(),
    );
    if (json['adult'] != null) {
      temp.adult = json['adult'];
    }
    if (json['budget'] != null) {
      temp.budget = json['budget'];
    }
    if (json['genres'] != null) {
      temp.genres = json['genres']
          .map<String>((genre) => genre['name'] as String)
          .toList();
    }
    if (json['homepage'] != null) {
      temp.homepage = json['homepage'];
    }
    return temp;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
      'popularity': popularity,
    };
    if (adult != null) {
      json['adult'] = adult;
    }
    if (budget != null) {
      json['budget'] = budget;
    }
    if (genres != null) {
      json['genres'] = genres;
    }
    if (homepage != null) {
      json['homepage'] = homepage;
    }
    return json;
  }
}
