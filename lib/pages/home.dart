import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tmdb_app/common_usage_widgets/movie_card.dart';
import 'package:tmdb_app/database/db.dart';
import 'package:tmdb_app/models/movie.dart';
import 'package:tmdb_app/pages/detailed_movie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Database db;
  bool isLoading = true;
  List<Movie>? movies;
  List<Movie>? filteredMovies;

  String searchQuery = '';
  String languageCode = 'en-US';
  bool isEnglish = true;

  Future<void> _getMovies() async {
    var box = Hive.box('cacheBox');

    try {
      final moviesRes = await db.getMovies(languageCode);
      setState(() {
        movies = moviesRes;
        filteredMovies = movies;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        List<dynamic> cachedData = box.get('movies', defaultValue: []);

        movies = cachedData.map<Movie>((json) {
          Map<String, dynamic> temp = Map<String, dynamic>.from(json);
          return Movie.fromJson(temp);
        }).toList();

        filteredMovies = movies;
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

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
      languageCode = isEnglish ? 'en-US' : 'hu-HU';
      _getMovies();
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
        actions: [
          IconButton(
            icon: isEnglish
                ? Image.asset('assets/american_flag.jpg')
                : Image.asset('assets/hungarian_flag.png'),
            onPressed: _toggleLanguage,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
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
                      return MovieCard(
                        movie: filteredMovies![index],
                        navToSingleMovie: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DetailedMovie(
                            movieId: filteredMovies![index].id,
                            languageCode: languageCode,
                          ),
                        )),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
