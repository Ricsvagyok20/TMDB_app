import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:tmdb_app/models/movie.dart';
import 'package:tmdb_app/secrets/secrets.dart';

final dbProvider = Provider<Database>((ref) => Database());

class Database {
  final String baseUrl = "https://api.themoviedb.org/3";
  final dio = Dio();

  Future<List<Movie>> getMovies(String language) async {
    Map<String, dynamic> queryParameters = {'language': language};
    final res = await getRequest('$baseUrl/movie/popular',
        queryParameters: queryParameters);

    var box = Hive.box('cacheBox');
    box.put('movies', res.data['results']);

    List<Movie> movies = (res.data['results'] as List)
        .map((json) => Movie.fromJson(json))
        .toList();
    return movies;
  }

  Future<Movie> getMovie(String movieId, String language) async {
    Map<String, dynamic> queryParameters = {'language': language};
    final res = await getRequest('$baseUrl/movie/$movieId',
        queryParameters: queryParameters);

    return Movie.fromJson(res.data);
  }

  dynamic getRequest(String url,
      {Map<String, dynamic>? queryParameters}) async {
    if (queryParameters == null) {
      queryParameters = {'api_key': tmdbApiKey};
    } else {
      queryParameters['api_key'] = tmdbApiKey;
    }
    final res = await dio.get(url,
        queryParameters: queryParameters,
        options: Options(headers: {
          'Authorization': 'Bearer $tmdbAccessToken',
          Headers.contentTypeHeader: 'application/json',
        }));
    return res;
  }
}
