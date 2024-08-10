import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_app/models/movie.dart';
import 'package:tmdb_app/secrets/secrets.dart';

final dbProvider = Provider<Database>((ref) => Database());

class Database {
  final String baseUrl = "https://api.themoviedb.org/3";
  final dio = Dio();

  Future<List<Movie>> getMovies({String? language}) async {
    final res = await getRequest('$baseUrl/movie/popular');
    print(res.data);
    List<Movie> movies = (res.data['results'] as List)
        .map((json) => Movie.fromJson(json))
        .toList();
    return movies;
  }

  dynamic getRequest(String url, {Map<String, Object>? params}) async {
    final res = await dio.get(url,
        queryParameters: {
          'api_key': tmdbApiKey,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $tmdbAccessToken',
          Headers.contentTypeHeader: 'application/json',
        }));
    return res;
  }
}
