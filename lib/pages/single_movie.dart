import 'package:flutter/material.dart';
import 'package:tmdb_app/models/movie.dart';

class SingleMovie extends StatelessWidget {
  const SingleMovie({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: const Center(child: Text('asd')),
    );
  }
}
