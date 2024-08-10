import 'package:flutter/material.dart';
import 'package:tmdb_app/models/movie.dart';
import 'package:tmdb_app/pages/single_movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SingleMovie(movie: movie))),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 30,
                  offset: const Offset(5, 10), // changes position of shadow
                ),
              ],
            ),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 110,
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        movie.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.yellow, size: 16),
                              const SizedBox(width: 4),
                              Text(movie.voteAverage.toStringAsFixed(1)),
                              const SizedBox(width: 16),
                              const Icon(Icons.favorite,
                                  color: Colors.red, size: 16),
                              const SizedBox(width: 4),
                              Text(movie.popularity.toString()),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(movie.overview,
                              maxLines: 3, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 36,
            left: 5,
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: movie.posterPath.isNotEmpty
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                        fit: BoxFit.fitHeight,
                      )
                    : Container(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
