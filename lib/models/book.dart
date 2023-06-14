class Book {
  final String title;
  final String subtitle;
  final List<String> authors;
  final List<String> categories;
  final String thumbnail;

  Book({
    required this.title,
    required this.subtitle,
    required this.authors,
    required this.categories,
    required this.thumbnail,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'],
      subtitle: json['subtitle'] ??
          '', // Subtitle might not be present for all books.
      authors: List<String>.from(json['authors'] ?? []),
      categories: List<String>.from(json['categories'] ?? []),
      thumbnail: json['imageLinks'] != null
          ? json['imageLinks']['thumbnail']
          : '', // ImageLinks might not be present for all books.
    );
  }
}
