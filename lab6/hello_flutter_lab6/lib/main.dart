import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find a Movie',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const GenreScreen(),
    );
  }
}

class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

const List<Movie> allMovies = [
  Movie(
    title: 'The Great Adventure',
    year: 2021,
    genres: ['Action', 'Adventure'],
    posterUrl: 'https://via.placeholder.com/300x450.png?text=Great+Adventure',
    rating: 7.8,
  ),
  Movie(
    title: 'Romantic Escape',
    year: 2019,
    genres: ['Romance', 'Drama'],
    posterUrl: 'https://via.placeholder.com/300x450.png?text=Romantic+Escape',
    rating: 6.9,
  ),
  Movie(
    title: 'Laugh Out Loud',
    year: 2020,
    genres: ['Comedy'],
    posterUrl: 'https://via.placeholder.com/300x450.png?text=Laugh+Out+Loud',
    rating: 7.1,
  ),
  Movie(
    title: 'Mystery Manor',
    year: 2018,
    genres: ['Thriller', 'Mystery'],
    posterUrl: 'https://via.placeholder.com/300x450.png?text=Mystery+Manor',
    rating: 8.2,
  ),
  Movie(
    title: 'Sci-Fi Odyssey',
    year: 2022,
    genres: ['Sci-Fi', 'Action'],
    posterUrl: 'https://via.placeholder.com/300x450.png?text=Sci-Fi+Odyssey',
    rating: 8.5,
  ),
  Movie(
    title: 'Family Tales',
    year: 2017,
    genres: ['Family', 'Drama'],
    posterUrl: 'https://via.placeholder.com/300x450.png?text=Family+Tales',
    rating: 7.0,
  ),
];

enum SortOption { az, za, year, rating }

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  String searchQuery = '';
  final Set<String> selectedGenres = {};
  SortOption selectedSort = SortOption.az;

  // derive a distinct genre list from movies
  List<String> get genres {
    final set = <String>{};
    for (final m in allMovies) {
      set.addAll(m.genres);
    }
    final list = set.toList()..sort();
    return list;
  }

  void clearFilters() {
    setState(() {
      searchQuery = '';
      selectedGenres.clear();
      selectedSort = SortOption.az;
    });
  }

  List<Movie> computeVisibleMovies() {
    final q = searchQuery.trim().toLowerCase();
    var list = allMovies.where((m) {
      final matchesQuery = q.isEmpty || m.title.toLowerCase().contains(q);
      final matchesGenres =
          selectedGenres.isEmpty ||
          m.genres.any((g) => selectedGenres.contains(g));
      return matchesQuery && matchesGenres;
    }).toList();

    switch (selectedSort) {
      case SortOption.az:
        list.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.za:
        list.sort((a, b) => b.title.compareTo(a.title));
        break;
      case SortOption.year:
        list.sort((a, b) => b.year.compareTo(a.year));
        break;
      case SortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final visibleMovies = computeVisibleMovies();
    return Scaffold(
      appBar: AppBar(title: const Text('Find a Movie')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Find a Movie',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search movies...',
                  ),
                  onChanged: (v) => setState(() => searchQuery = v),
                ),
              ),
              const SizedBox(height: 12),

              // Genre chips and badge + Clear
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: genres.map((g) {
                        final selected = selectedGenres.contains(g);
                        return ChoiceChip(
                          label: Text(g),
                          selected: selected,
                          onSelected: (_) => setState(() {
                            if (selected) {
                              selectedGenres.remove(g);
                            } else {
                              selectedGenres.add(g);
                            }
                          }),
                        );
                      }).toList(),
                    ),
                  ),
                  if (selectedGenres.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${selectedGenres.length}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),

              // Sort + Clear button
              Row(
                children: [
                  DropdownButton<SortOption>(
                    value: selectedSort,
                    items: const [
                      DropdownMenuItem(
                        value: SortOption.az,
                        child: Text('A–Z'),
                      ),
                      DropdownMenuItem(
                        value: SortOption.za,
                        child: Text('Z–A'),
                      ),
                      DropdownMenuItem(
                        value: SortOption.year,
                        child: Text('Year'),
                      ),
                      DropdownMenuItem(
                        value: SortOption.rating,
                        child: Text('Rating'),
                      ),
                    ],
                    onChanged: (v) => setState(() {
                      if (v != null) selectedSort = v;
                    }),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: clearFilters,
                    child: const Text('Clear filters'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Movie list
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 800;
                    if (visibleMovies.isEmpty) {
                      return const Center(
                        child: Text('No movies match your filters'),
                      );
                    }
                    if (isWide) {
                      return GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 1.2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children: visibleMovies
                            .map((m) => MovieCard(movie: m))
                            .toList(),
                      );
                    }
                    return ListView.separated(
                      itemCount: visibleMovies.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          MovieCard(movie: visibleMovies[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final imgWidth = (constraints.maxWidth >= 300) ? 90.0 : 70.0;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    movie.posterUrl,
                    width: imgWidth,
                    height: imgWidth * 1.5,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      width: imgWidth,
                      height: imgWidth * 1.5,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${movie.year} • ${movie.genres.join(', ')}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rating: ${movie.rating.toStringAsFixed(1)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
