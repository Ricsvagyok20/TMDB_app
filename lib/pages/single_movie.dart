import 'package:flutter/material.dart';
import 'package:tmdb_app/database/db.dart';
import 'package:tmdb_app/models/movie.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailedMovie extends StatefulWidget {
  const DetailedMovie(
      {super.key, required this.movieId, required this.languageCode});

  final int movieId;
  final String languageCode;

  @override
  State<DetailedMovie> createState() => _DetailedMovieState();
}

class _DetailedMovieState extends State<DetailedMovie> {
  late Database db;
  bool isLoading = true;
  String errorMessage = '';
  late Movie movie;

  Future<void> _getMovie() async {
    try {
      final moviesRes =
          await db.getMovie('${widget.movieId}', widget.languageCode);
      setState(() {
        movie = moviesRes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        print('Error $e');
        isLoading = false;
        errorMessage = 'Failed to load movie details.';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    db = Database();
    _getMovie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
      ),
      body: isLoading
          ? Center(
              child: Text(errorMessage),
            )
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                CircleAvatar(
                  radius: 50,
                  child: ClipOval(
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                      fit: BoxFit.cover,
                      width: 100,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    if (movie.homepage != null && movie.homepage!.isNotEmpty) {
                      Uri url = Uri.parse(movie.homepage!);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }
                  },
                  child: Text(
                    movie.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: movie.genres?.map((genre) {
                          return Chip(
                            label: Text(genre),
                          );
                        }).toList() ??
                        [],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  movie.overview,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: Text('Budget: \$${movie.budget ?? 'N/A'}'),
                ),
                ListTile(
                  leading: const Icon(Icons.trending_up),
                  title: Text(
                      'Popularity: ${movie.popularity.toStringAsFixed(1)}'),
                ),
                ListTile(
                  leading: const Icon(Icons.eighteen_up_rating_rounded),
                  title: Text('Adult: ${movie.adult ?? false}'),
                ),
                ListTile(
                  leading: const Icon(Icons.star),
                  title: Text(
                      'Vote Average: ${movie.voteAverage.toStringAsFixed(1)}'),
                ),
                ListTile(
                  leading: const Icon(Icons.date_range),
                  title: Text('Release Date: ${movie.releaseDate}'),
                ),
              ],
            ),
    );
  }
}
