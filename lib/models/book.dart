class Book {
  final String title;
  final String subtitle;
  final List<String> authors;
  final List<String> categories;
  final String thumbnailUrl;

  Book({
    required this.title,
    required this.subtitle,
    required this.authors,
    required this.categories,
    required this.thumbnailUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};

    return Book(
      title: volumeInfo['title'] ?? '',
      subtitle: volumeInfo['subtitle'] ?? '',
      authors: volumeInfo['authors'] != null
          ? List<String>.from(volumeInfo['authors'])
          : [],
      categories: volumeInfo['categories'] != null
          ? List<String>.from(volumeInfo['categories'])
          : [],
      thumbnailUrl: volumeInfo['imageLinks'] != null
          ? volumeInfo['imageLinks']['thumbnail'] ?? ''
          : '',
    );
  }
}
