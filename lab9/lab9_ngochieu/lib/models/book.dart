class Book {
  final String id;
  final String title;
  final String author;
  final String genre;
  final int year;
  final double rating;
  final String description;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.year,
    required this.rating,
    required this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Unknown Title',
      author: json['author']?.toString() ?? 'Unknown Author',
      genre: json['genre']?.toString() ?? 'Unknown Genre',
      year: json['year'] is int ? json['year'] as int : int.tryParse(json['year']?.toString() ?? '') ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'genre': genre,
      'year': year,
      'rating': rating,
      'description': description,
    };
  }
}
