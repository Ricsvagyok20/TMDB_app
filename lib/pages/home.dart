import 'package:flutter/material.dart';
import 'package:tmdb_app/common_usage_widgets/movie_card.dart';
import 'package:tmdb_app/database/db.dart';
import 'package:tmdb_app/models/movie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Database db;
  bool isLoading = true;
  String errorMessage = '';
  List<Movie>? movies;
  List<Movie>? filteredMovies;
  String searchQuery = '';

  Future<void> _getMovies() async {
    try {
      final moviesRes = await db.getMovies();
      setState(() {
        movies = moviesRes;
        filteredMovies = moviesRes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load movie details.';
      });
    }
  }

  void _filterMovies(String query) {
    setState(() {
      searchQuery = query;
      filteredMovies = movies!.where((movie) {
        return movie.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    db = Database();
    _getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Movies")),
      ),
      body: isLoading
          ? Center(
              child: Text(errorMessage),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: _filterMovies,
                    decoration: InputDecoration(
                      hintText: 'Search movies...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredMovies!.length,
                    itemBuilder: (context, index) {
                      return MovieCard(movie: filteredMovies![index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
